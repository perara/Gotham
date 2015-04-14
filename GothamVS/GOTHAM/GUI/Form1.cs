using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Windows.Forms;
using GMap.NET;
using GMap.NET.WindowsForms;
using GMap.NET.WindowsForms.Markers;
using Gotham.Model;
using Gotham.Model.Tools;
using GOTHAM.Repository.Abstract;
using Gotham.Application.Generators;


// ReSharper disable LocalizableElement

namespace Gotham.Application.GUI
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        IList<NodeEntity> _nodes;
        IList<CableEntity> _cables;
        GMapOverlay _markersOverlay;

        Brush _tempBrush;
        List<GMapRoute> _tempRoutes;

        private void Form1_Load(object sender, EventArgs e)
        {

            // Initialize map:
            MainMap.MapProvider = GMap.NET.MapProviders.GoogleSatelliteMapProvider.Instance;
            GMaps.Instance.Mode = AccessMode.ServerOnly;
            MainMap.Position = new PointLatLng(-25.971684, 32.589759);
            MainMap.DragButton = MouseButtons.Left;

            _markersOverlay = new GMapOverlay("markers");
            MainMap.Overlays.Add(_markersOverlay);
            MainMap.MaxZoom = 10;
            MainMap.MinZoom = 3;
            MainMap.Zoom = 3;
            MainMap.Position = new PointLatLng(30, 0);

            LoadEntities();

            CableGenerator.ConnectNodesToCables();

            DrawNodes();
            DrawCables();
        }

        public void LoadEntities()
        {
            //using (var session = EntityManager.GetSessionFactory().OpenSession())
            //{
            var work = new UnitOfWork();
            _nodes = work.GetRepository<NodeEntity>().All().ToList();
            _cables = work.GetRepository<CableEntity>().All().ToList();
            work.Dispose();
                //_nodes = session.CreateCriteria<NodeEntity>().List<NodeEntity>();
                //_cables = session.CreateCriteria<CableEntity>().List<CableEntity>();
            //}
        }

        public void DrawNodes()
        {
            foreach (var node in _nodes)
            {
                GMarkerGoogleType markerType;
                var type = node.Tier.Id;

                if (type == 1) markerType = GMarkerGoogleType.red_small;
                else if (type == 1) markerType = GMarkerGoogleType.green_small;
                else if (type == 1) markerType = GMarkerGoogleType.yellow_small;
                else if (type == 1) markerType = GMarkerGoogleType.blue_small;
                else markerType = GMarkerGoogleType.orange;

                var marker = new GMarkerGoogle(new PointLatLng(node.Lat, node.Lng), markerType);

                _markersOverlay.Markers.Add(marker);
                marker.ToolTipText = node.Name + "\n" + node.CountryCode;
                marker.Tag = node;

            }
        }


        public void DrawCables()
        {

            var random = new Random();
            foreach (var cable in _cables)
            {
                //if (cable.year > 2014) continue;

                var parts = new List<PointLatLng>();
                var color = Color.FromArgb(150, random.Next(255), random.Next(255), random.Next(255));
                var width = Math.Max(Math.Min((float)(cable.Capacity * 0.001), 7), 2);

                foreach (var part in cable.CableParts)
                {
                    if (part.Number == 0)
                    {
                        var r1 = new GMapRoute(parts, "route")
                        {
                            Stroke = new Pen(new SolidBrush(color), width),
                            IsHitTestVisible = true,
                            Name = cable.Name,
                            Tag = cable
                        };
                        // color; //Color.FromArgb(50, 20, 20, 200);
                        _markersOverlay.Routes.Add(r1);
                        parts.Clear();
                    }

                    parts.Add(new PointLatLng(part.Lat, part.Lng));
                }// End foreach

                var r2 = new GMapRoute(parts, "route")
                {
                    Stroke = new Pen(new SolidBrush(color), width),
                    IsHitTestVisible = true,
                    Name = cable.Name,
                    Tag = cable
                };
                // color; //Color.FromArgb(50, 20, 20, 200);
                _markersOverlay.Routes.Add(r2);
            }
        }


        private void MainMap_MouseUp(object sender, MouseEventArgs e)
        {
            var point = MousePosition;
            lbl_lat.Text = MainMap.FromLocalToLatLng(point.X, point.Y).Lat.ToString(CultureInfo.InvariantCulture);
            lbl_lng.Text = MainMap.FromLocalToLatLng(point.X, point.Y).Lng.ToString(CultureInfo.InvariantCulture);
        }

        private void MainMap_OnRouteClick(GMapRoute item, MouseEventArgs e)
        {
            var cable = (CableEntity)item.Tag;

            lbl_lat.Text = "";
            lbl_lng.Text = "";
            tb_name.Text = cable.Name;
            tb_Distance.Text = cable.Distance.ToString(CultureInfo.InvariantCulture);
            tb_id.Text = cable.Id.ToString();

            if (_tempRoutes != null)
            {
                foreach (var route in _tempRoutes)
                {
                    route.Stroke.Brush = _tempBrush;
                }
            }

            _tempBrush = item.Stroke.Brush;
            _tempRoutes = new List<GMapRoute>();

            foreach (var route in _markersOverlay.Routes.Where(route => route.Name == item.Name))
            {
                _tempRoutes.Add(route);
                route.Stroke.Brush = new SolidBrush((Color.White));
            }


            tb_nodes.Text = "";

            foreach (var node in cable.Nodes)
            {
                tb_nodes.Text += node.Name + "\r\n";
            }

        }

        private void MainMap_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            var node = (NodeEntity)item.Tag;

            tb_cables.Text = "";
            tb_Distance.Text = "";
            tb_name.Text = node.Name;
            tb_id.Text = node.Id.ToString();

            foreach (var cable in node.Cables.Where(cable => cable.Year <= 2014))
            {
                tb_cables.Text += cable.Name + "\r\n";
            }
        }
    }
}



