namespace GOTHAM_BACKEND_DEBUG
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
            this.lbl_name = new System.Windows.Forms.Label();
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
            this.MainMap.Location = new System.Drawing.Point(12, 12);
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
            this.MainMap.Size = new System.Drawing.Size(1900, 939);
            this.MainMap.TabIndex = 0;
            this.MainMap.Zoom = 0D;
            this.MainMap.OnRouteClick += new GMap.NET.WindowsForms.RouteClick(this.MainMap_OnRouteClick);
            this.MainMap.MouseUp += new System.Windows.Forms.MouseEventHandler(this.MainMap_MouseUp);
            // 
            // lbl_lat
            // 
            this.lbl_lat.AutoSize = true;
            this.lbl_lat.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_lat.Location = new System.Drawing.Point(38, 994);
            this.lbl_lat.Name = "lbl_lat";
            this.lbl_lat.Size = new System.Drawing.Size(113, 25);
            this.lbl_lat.TabIndex = 1;
            this.lbl_lat.Text = "LATITUDE";
            // 
            // lbl_lng
            // 
            this.lbl_lng.AutoSize = true;
            this.lbl_lng.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_lng.Location = new System.Drawing.Point(409, 994);
            this.lbl_lng.Name = "lbl_lng";
            this.lbl_lng.Size = new System.Drawing.Size(133, 25);
            this.lbl_lng.TabIndex = 2;
            this.lbl_lng.Text = "LONGITUDE";
            // 
            // lbl_name
            // 
            this.lbl_name.AutoSize = true;
            this.lbl_name.Font = new System.Drawing.Font("Microsoft Sans Serif", 26.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lbl_name.Location = new System.Drawing.Point(858, 973);
            this.lbl_name.Name = "lbl_name";
            this.lbl_name.Size = new System.Drawing.Size(377, 39);
            this.lbl_name.TabIndex = 3;
            this.lbl_name.Text = "                                        ";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1904, 1042);
            this.Controls.Add(this.lbl_name);
            this.Controls.Add(this.lbl_lng);
            this.Controls.Add(this.lbl_lat);
            this.Controls.Add(this.MainMap);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private GMap.NET.WindowsForms.GMapControl MainMap;
        private System.Windows.Forms.Label lbl_lat;
        private System.Windows.Forms.Label lbl_lng;
        private System.Windows.Forms.Label lbl_name;
    }
}

