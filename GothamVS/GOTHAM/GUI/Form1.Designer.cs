namespace Gotham.Application.GUI
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.MainMap = new GMap.NET.WindowsForms.GMapControl();
            this.lbl_lat = new System.Windows.Forms.Label();
            this.lbl_lng = new System.Windows.Forms.Label();
            this.lbl_list_type = new System.Windows.Forms.Label();
            this.lbl_CableList = new System.Windows.Forms.Label();
            this.lbl_NodeList = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.lbl_distance = new System.Windows.Forms.Label();
            this.tb_Distance = new System.Windows.Forms.TextBox();
            this.tb_id = new System.Windows.Forms.TextBox();
            this.lbl_id = new System.Windows.Forms.Label();
            this.tb_name = new System.Windows.Forms.TextBox();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.button1 = new System.Windows.Forms.Button();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.SuspendLayout();
            // 
            // MainMap
            // 
            this.MainMap.Bearing = 0F;
            this.MainMap.CanDragMap = true;
            this.MainMap.EmptyTileColor = System.Drawing.Color.Navy;
            this.MainMap.GrayScaleMode = false;
            this.MainMap.HelperLineOption = GMap.NET.WindowsForms.HelperLineOptions.DontShow;
            this.MainMap.LevelsKeepInMemmory = 5;
            this.MainMap.Location = new System.Drawing.Point(8, 6);
            this.MainMap.MarkersEnabled = true;
            this.MainMap.MaxZoom = 17;
            this.MainMap.MinZoom = 2;
            this.MainMap.MouseWheelZoomType = GMap.NET.MouseWheelZoomType.MousePositionAndCenter;
            this.MainMap.Name = "MainMap";
            this.MainMap.NegativeMode = false;
            this.MainMap.PolygonsEnabled = true;
            this.MainMap.RetryLoadTile = 0;
            this.MainMap.RoutesEnabled = true;
            this.MainMap.ScaleMode = GMap.NET.WindowsForms.ScaleModes.Integer;
            this.MainMap.SelectedAreaFillColor = System.Drawing.Color.FromArgb(((int)(((byte)(33)))), ((int)(((byte)(65)))), ((int)(((byte)(105)))), ((int)(((byte)(225)))));
            this.MainMap.ShowTileGridLines = false;
            this.MainMap.Size = new System.Drawing.Size(1673, 922);
            this.MainMap.TabIndex = 0;
            this.MainMap.Zoom = 0D;
            this.MainMap.OnMarkerClick += new GMap.NET.WindowsForms.MarkerClick(this.MainMap_OnMarkerClick);
            this.MainMap.OnRouteClick += new GMap.NET.WindowsForms.RouteClick(this.MainMap_OnRouteClick);
            this.MainMap.Load += new System.EventHandler(this.MainMap_Load);
            this.MainMap.MouseUp += new System.Windows.Forms.MouseEventHandler(this.MainMap_MouseUp);
            // 
            // lbl_lat
            // 
            this.lbl_lat.AutoSize = true;
            this.lbl_lat.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_lat.Location = new System.Drawing.Point(1758, 195);
            this.lbl_lat.Name = "lbl_lat";
            this.lbl_lat.Size = new System.Drawing.Size(113, 25);
            this.lbl_lat.TabIndex = 1;
            this.lbl_lat.Text = "LATITUDE";
            // 
            // lbl_lng
            // 
            this.lbl_lng.AutoSize = true;
            this.lbl_lng.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_lng.Location = new System.Drawing.Point(1735, 220);
            this.lbl_lng.Name = "lbl_lng";
            this.lbl_lng.Size = new System.Drawing.Size(133, 25);
            this.lbl_lng.TabIndex = 2;
            this.lbl_lng.Text = "LONGITUDE";
            // 
            // lbl_list_type
            // 
            this.lbl_list_type.AutoSize = true;
            this.lbl_list_type.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_list_type.Location = new System.Drawing.Point(1758, 111);
            this.lbl_list_type.Name = "lbl_list_type";
            this.lbl_list_type.Size = new System.Drawing.Size(110, 13);
            this.lbl_list_type.TabIndex = 4;
            this.lbl_list_type.Text = "Connected Cables";
            // 
            // lbl_CableList
            // 
            this.lbl_CableList.AutoSize = true;
            this.lbl_CableList.Location = new System.Drawing.Point(1683, 45);
            this.lbl_CableList.Name = "lbl_CableList";
            this.lbl_CableList.Size = new System.Drawing.Size(0, 13);
            this.lbl_CableList.TabIndex = 5;
            // 
            // lbl_NodeList
            // 
            this.lbl_NodeList.AutoSize = true;
            this.lbl_NodeList.Location = new System.Drawing.Point(1683, 543);
            this.lbl_NodeList.Name = "lbl_NodeList";
            this.lbl_NodeList.Size = new System.Drawing.Size(0, 13);
            this.lbl_NodeList.TabIndex = 7;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(1760, 3);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(108, 13);
            this.label2.TabIndex = 6;
            this.label2.Text = "Connected Nodes";
            // 
            // lbl_distance
            // 
            this.lbl_distance.AutoSize = true;
            this.lbl_distance.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_distance.Location = new System.Drawing.Point(1683, 280);
            this.lbl_distance.Name = "lbl_distance";
            this.lbl_distance.Size = new System.Drawing.Size(72, 20);
            this.lbl_distance.TabIndex = 8;
            this.lbl_distance.Text = "Distance";
            // 
            // tb_Distance
            // 
            this.tb_Distance.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tb_Distance.Location = new System.Drawing.Point(1761, 280);
            this.tb_Distance.Name = "tb_Distance";
            this.tb_Distance.Size = new System.Drawing.Size(107, 26);
            this.tb_Distance.TabIndex = 9;
            // 
            // tb_id
            // 
            this.tb_id.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tb_id.Location = new System.Drawing.Point(1761, 248);
            this.tb_id.Name = "tb_id";
            this.tb_id.Size = new System.Drawing.Size(107, 26);
            this.tb_id.TabIndex = 11;
            // 
            // lbl_id
            // 
            this.lbl_id.AutoSize = true;
            this.lbl_id.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_id.Location = new System.Drawing.Point(1729, 251);
            this.lbl_id.Name = "lbl_id";
            this.lbl_id.Size = new System.Drawing.Size(26, 20);
            this.lbl_id.TabIndex = 10;
            this.lbl_id.Text = "ID";
            // 
            // tb_name
            // 
            this.tb_name.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.tb_name.Location = new System.Drawing.Point(1687, 312);
            this.tb_name.Name = "tb_name";
            this.tb_name.Size = new System.Drawing.Size(181, 35);
            this.tb_name.TabIndex = 12;
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(0, 2);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(1885, 960);
            this.tabControl1.TabIndex = 13;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.MainMap);
            this.tabPage1.Controls.Add(this.tb_Distance);
            this.tabPage1.Controls.Add(this.tb_id);
            this.tabPage1.Controls.Add(this.tb_name);
            this.tabPage1.Controls.Add(this.lbl_id);
            this.tabPage1.Controls.Add(this.lbl_lat);
            this.tabPage1.Controls.Add(this.lbl_lng);
            this.tabPage1.Controls.Add(this.lbl_distance);
            this.tabPage1.Controls.Add(this.lbl_list_type);
            this.tabPage1.Controls.Add(this.label2);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(1877, 934);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Map";
            this.tabPage1.UseVisualStyleBackColor = true;
            this.tabPage1.Click += new System.EventHandler(this.tabPage1_Click);
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.button1);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(1877, 934);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Generators";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(37, 43);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(159, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "Generate Nodes";
            this.button1.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1884, 961);
            this.Controls.Add(this.tabControl1);
            this.Controls.Add(this.lbl_NodeList);
            this.Controls.Add(this.lbl_CableList);
            this.Name = "Form1";
            this.Text = "Gotham Generator";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private GMap.NET.WindowsForms.GMapControl MainMap;
        private System.Windows.Forms.Label lbl_lat;
        private System.Windows.Forms.Label lbl_lng;
        private System.Windows.Forms.Label lbl_list_type;
        private System.Windows.Forms.Label lbl_CableList;
        private System.Windows.Forms.Label lbl_NodeList;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label lbl_distance;
        private System.Windows.Forms.TextBox tb_Distance;
        private System.Windows.Forms.TextBox tb_id;
        private System.Windows.Forms.Label lbl_id;
        private System.Windows.Forms.TextBox tb_name;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Button button1;
    }
}

