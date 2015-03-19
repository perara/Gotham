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
                switch (node.tier.id)
                {
                    case 1:
                        marker = new GMarkerGoogle(new PointLatLng(node.lat, node.lng), GMarkerGoogleType.red_small);
                        break;
                    case 2:
                        marker = new GMarkerGoogle(new PointLatLng(node.lat, node.lng), GMarkerGoogleType.green_small);
                        break;
                    case 3:
                        marker = new GMarkerGoogle(new PointLatLng(node.lat, node.lng), GMarkerGoogleType.yellow_small);
                        break;
                    case 4:
                        marker = new GMarkerGoogle(new PointLatLng(node.lat, node.lng), GMarkerGoogleType.blue_small);
                        break;
                    default:
                        marker = new GMarkerGoogle(new PointLatLng(node.lat, node.lng), GMarkerGoogleType.orange);
                        break;
                }

                var tt = new GMapToolTip(marker);

                markersOverlay.Markers.Add(marker);
                marker.ToolTipText = node.name.ToString() + "\n" + node.countryCode.ToString();
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
                var width = Math.Max(Math.Min((float)(cable.capacity * 0.001), 7), 2);

                foreach (var part in cable.cableParts)
                {
                    if (part.number == 0)
                    {
                        GMapRoute r1 = new GMapRoute(parts, "route");
                        r1.Stroke = new Pen(new SolidBrush(color), width); // color; //Color.FromArgb(50, 20, 20, 200);
                        r1.IsHitTestVisible = true;
                        r1.Name = cable.name;
                        r1.Tag = cable;
                        markersOverlay.Routes.Add(r1);
                        parts.Clear();
                    }

                    parts.Add(new PointLatLng(part.lat, part.lng));
                }// End foreach

                GMapRoute r2 = new GMapRoute(parts, "route");
                r2.Stroke = new Pen(new SolidBrush(color), width); // color; //Color.FromArgb(50, 20, 20, 200);
                r2.IsHitTestVisible = true;
                r2.Name = cable.name;
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
           
            lbl_name.Text = item.Name;

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

            var cables = (CableEntity)item.Tag;

            foreach (var cable in cables.nodes)
            {
                lbl_NodeList.Text += "\n" + cable.name;
            }
        }

        private void MainMap_OnMarkerClick(GMapMarker item, MouseEventArgs e)
        {
            lbl_CableList.Text = "";

            var node = (NodeEntity)item.Tag;

            foreach (var cable in node.cables)
            {
                if (cable.year > 2014) continue;
                lbl_CableList.Text += "\n" + cable.name;
            }
        }

        private void MainMap_Load(object sender, EventArgs e)
        {

        }
    }
}



