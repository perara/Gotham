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
using GOTHAM.Model;
using GMap.NET.MapProviders;
using GMap.NET.WindowsForms;
using GMap.NET.WindowsForms.Markers;
using GOTHAM.Model.Tools;

namespace GOTHAM_BACKEND_DEBUG
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        

        private void Form1_Load(object sender, EventArgs e)
        {
            
            // Initialize map:
            MainMap.MapProvider = GMap.NET.MapProviders.GoogleMapProvider.Instance;
            GMap.NET.GMaps.Instance.Mode = GMap.NET.AccessMode.ServerOnly;
            MainMap.Position = new PointLatLng(-25.971684,32.589759);

            GMapOverlay markersOverlay = new GMapOverlay("markers");
            MainMap.Overlays.Add(markersOverlay);
            

            IList<NodeEntity> nodes = null;
            IList<CableEntity> cables = null;
            IList<LocationEntity> locations = null;
            
            using (var session = EntityManager.GetSessionFactory().OpenSession())
            {

                nodes = session.CreateCriteria<NodeEntity>().List<NodeEntity>();
                //nodes = session.CreateCriteria<NodeEntity>().List<NodeEntity>();
                cables = session.CreateCriteria<CableEntity>().List<CableEntity>();

            }

            foreach (NodeEntity node in nodes)
            {
                var marker = new GMarkerGoogle(new PointLatLng(node.latitude, node.longitude), GMarkerGoogleType.green);
                var tt = new GMapToolTip(marker);
                
                markersOverlay.Markers.Add(marker);
                marker.ToolTipText = node.name.ToString();

            }


            int count = 0;
            var rg = new Random();
            foreach (CableEntity cable in cables)
            {
                count++;
                
                var point = new PointLatLng(cable.node1.latitude, cable.node1.longitude);
                var point2 = new PointLatLng(cable.node2.latitude, cable.node2.longitude);

                List<PointLatLng> points = new List<PointLatLng>();
                points.Add(point);
                points.Add(point2);

                //MapRoute route = GMap.NET.MapProviders.GoogleMapProvider.Instance.GetRoute(point, point2, false, false, 15);
                GMapRoute r = new GMapRoute(points, "route");
                r.Stroke.Color = Color.Red;

                markersOverlay.Routes.Add(r);

            }
            MainMap.ZoomAndCenterMarkers("route");

        }
       
    }
}
