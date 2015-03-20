using GMap.NET;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using GOTHAM.Tools;
using GMap.NET.MapProviders;
using GMap.NET.WindowsForms;
using GMap.NET.WindowsForms.Markers;
using GOTHAM.Model;
using GOTHAM.Model.Tools;

namespace GOTHAM_BACKEND_DEBUG
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        IList<NodeEntity> nodes = null;
        IList<CableEntity> cables = null;
        GMapOverlay markersOverlay = null;
        
        Brush tempBrush = null;
        List<GMapRoute> tempRoutes = null;

        private void Form1_Load(object sender, EventArgs e)
        {

            // Initialize map:
            MainMap.MapProvider = GMap.NET.MapProviders.GoogleSatelliteMapProvider.Instance;
            GMap.NET.GMaps.Instance.Mode = GMap.NET.AccessMode.ServerOnly;
            MainMap.Position = new PointLatLng(-25.971684, 32.589759);
            MainMap.DragButton = MouseButtons.Left;

            markersOverlay = new GMapOverlay("markers");
            MainMap.Overlays.Add(markersOverlay);
            MainMap.MaxZoom = 10;
            MainMap.MinZoom = 3;
            MainMap.Zoom = 3;
            MainMap.Position = new PointLatLng(30, 0);

            loadEntities();
            drawNodes();
            drawCables();
        }

        public void loadEntities()
        {
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {
                nodes = session.CreateCriteria<NodeEntity>().List<NodeEntity>();
                cables = session.CreateCriteria<CableEntity>().List<CableEntity>();

                Console.WriteLine();

            }
        }

        public void drawNodes()
        {
            foreach (NodeEntity node in nodes)
            {
                GMarkerGoogle marker = null;
                // TODO Find cleaner switch case
                switch (node.Tier.Id)
                {
                    case 1:
                        marker = new GMarkerGoogle(new PointLatLng(node.Lat, node.Lng), GMarkerGoogleType.red_small);
                        break;
                    case 2:
                        marker = new GMarkerGoogle(new PointLatLng(node.Lat, node.Lng), GMarkerGoogleType.green_small);
                        break;
                    case 3:
                        marker = new GMarkerGoogle(new PointLatLng(node.Lat, node.Lng), GMarkerGoogleType.yellow_small);
                        break;
                    case 4:
                        marker = new GMarkerGoogle(new PointLatLng(node.Lat, node.Lng), GMarkerGoogleType.blue_small);
                        break;
                    default:
                        marker = new GMarkerGoogle(new PointLatLng(node.Lat, node.Lng), GMarkerGoogleType.orange);
                        break;
                }

                var tt = new GMapToolTip(marker);

                markersOverlay.Markers.Add(marker);
                marker.ToolTipText = node.Name.ToString() + "\n" + node.CountryCode.ToString();
                marker.Tag = node;
                
            }
        }


        public void drawCables()
        {

            var random = new Random();
            foreach (var cable in cables)
            {
                //if (cable.year > 2014) continue;

                var parts = new List<PointLatLng>();
                var color = Color.FromArgb(150, random.Next(255), random.Next(255), random.Next(255));
                var width = Math.Max(Math.Min((float)(cable.Capacity * 0.001), 7), 2);

                foreach (var part in cable.CableParts)
                {
                    if (part.Number == 0)
                    {
                        GMapRoute r1 = new GMapRoute(parts, "route");
                        r1.Stroke = new Pen(new SolidBrush(color), width); // color; //Color.FromArgb(50, 20, 20, 200);
                        r1.IsHitTestVisible = true;
                        r1.Name = cable.Name;
                        r1.Tag = cable;
                        markersOverlay.Routes.Add(r1);
                        parts.Clear();
                    }

                    parts.Add(new PointLatLng(part.Lat, part.Lng));
                }// End foreach

                GMapRoute r2 = new GMapRoute(parts, "route");
                r2.Stroke = new Pen(new SolidBrush(color), width); // color; //Color.FromArgb(50, 20, 20, 200);
                r2.IsHitTestVisible = true;
                r2.Name = cable.Name;
                r2.Tag = cable;
                markersOverlay.Routes.Add(r2);
            }
        }


        private void MainMap_MouseUp(object sender, MouseEventArgs e)
        {
            var point = MousePosition;
            lbl_lat.Text = MainMap.FromLocalToLatLng(point.X, point.Y).Lat.ToString();
            lbl_lng.Text = MainMap.FromLocalToLatLng(point.X, point.Y).Lng.ToString();
        }

        private void MainMap_OnRouteClick(GMapRoute item, MouseEventArgs e)
        {
            var cable = (CableEntity)item.Tag;

            lbl_lat.Text = "";
            lbl_lng.Text = "";
            tb_name.Text = item.Name;
            tb_Distance.Text = cable.Distance.ToString();
            tb_id.Text = cable.Id.ToString();

            if (tempRoutes != null)
            {
                foreach (var route in tempRoutes)
                {
                        route.Stroke.Brush = tempBrush;
                }
            }

            tempBrush = item.Stroke.Brush;
            tempRoutes = new List<GMapRoute>();

            foreach (var route in markersOverlay.Routes)
            {
                if (route.Name == item.Name)
                {
                    tempRoutes.Add(route);
                    route.Stroke.Brush = new SolidBrush((Color.White));
                }
            }


            lbl_NodeList.Text = "";

            foreach (var node in cable.Nodes)
            {
                lbl_NodeList.Text += "\n" + cable.Name;
            }
        }

        private void MainMap_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            var node = (NodeEntity)item.Tag;

            lbl_CableList.Text = "";
            tb_Distance.Text = "";
            tb_id.Text = node.Id.ToString();

            foreach (var cable in node.Cables)
            {
                if (cable.Year > 2014) continue;
                lbl_CableList.Text += "\n" + cable.Name;
            }
        }

        private void MainMap_Load(object sender, EventArgs e)
        {

        }
    }
}



