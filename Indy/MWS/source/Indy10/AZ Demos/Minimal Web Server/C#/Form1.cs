using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using Indy.Sockets;

namespace MWS {
	public class Form1 : System.Windows.Forms.Form {
		private System.ComponentModel.Container components = null;

    private HTTPServer FHTTP;

    private void FHTTP_OnCommandGet(
      Context AContext,
      HTTPRequestInfo ARequestInfo,
      HTTPResponseInfo AResponseInfo
      ) {
      AResponseInfo.ContentText = "Hello World. It is " + DateTime.Now.ToShortTimeString();
    }

		public Form1() {
			InitializeComponent();
      FHTTP = new HTTPServer();
      FHTTP.OnCommandGet += new TIdHTTPGetEvent(FHTTP_OnCommandGet);
      FHTTP.Active = true;
		}

		protected override void Dispose( bool disposing ) {
			if( disposing ) {
        FHTTP.Active = false;
				if (components != null)  {
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.components = new System.ComponentModel.Container();
			this.Size = new System.Drawing.Size(300,300);
			this.Text = "Form1";
		}
		#endregion

		[STAThread]
		static void Main() {
			Application.Run(new Form1());
		}
	}
}
