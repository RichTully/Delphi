using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using Indy.Sockets;

namespace SendMail {
	public class Form1 : System.Windows.Forms.Form {
    private System.Windows.Forms.Panel panel1;
    private System.Windows.Forms.Label label1;
    private System.Windows.Forms.Label label2;
    private System.Windows.Forms.Label label3;
    private System.Windows.Forms.Label label4;
    private System.Windows.Forms.Button butnSendMail;
    private System.Windows.Forms.TextBox textMsg;
    private System.Windows.Forms.TextBox textSubject;
    private System.Windows.Forms.TextBox textTo;
    private System.Windows.Forms.TextBox textFrom;
    private System.Windows.Forms.TextBox textSMTPServer;
    private System.Windows.Forms.ListBox lboxStatus;
		private System.ComponentModel.Container components = null;

		public Form1() {
			InitializeComponent();
		}

		protected override void Dispose( bool disposing ) {
			if( disposing ) {
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
      this.panel1 = new System.Windows.Forms.Panel();
      this.butnSendMail = new System.Windows.Forms.Button();
      this.textSMTPServer = new System.Windows.Forms.TextBox();
      this.textSubject = new System.Windows.Forms.TextBox();
      this.textTo = new System.Windows.Forms.TextBox();
      this.textFrom = new System.Windows.Forms.TextBox();
      this.label4 = new System.Windows.Forms.Label();
      this.label3 = new System.Windows.Forms.Label();
      this.label2 = new System.Windows.Forms.Label();
      this.label1 = new System.Windows.Forms.Label();
      this.textMsg = new System.Windows.Forms.TextBox();
      this.lboxStatus = new System.Windows.Forms.ListBox();
      this.panel1.SuspendLayout();
      this.SuspendLayout();
      // 
      // panel1
      // 
      this.panel1.Controls.Add(this.butnSendMail);
      this.panel1.Controls.Add(this.textSMTPServer);
      this.panel1.Controls.Add(this.textSubject);
      this.panel1.Controls.Add(this.textTo);
      this.panel1.Controls.Add(this.textFrom);
      this.panel1.Controls.Add(this.label4);
      this.panel1.Controls.Add(this.label3);
      this.panel1.Controls.Add(this.label2);
      this.panel1.Controls.Add(this.label1);
      this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
      this.panel1.Location = new System.Drawing.Point(0, 0);
      this.panel1.Name = "panel1";
      this.panel1.Size = new System.Drawing.Size(408, 112);
      this.panel1.TabIndex = 0;
      // 
      // butnSendMail
      // 
      this.butnSendMail.Location = new System.Drawing.Point(328, 8);
      this.butnSendMail.Name = "butnSendMail";
      this.butnSendMail.TabIndex = 8;
      this.butnSendMail.Text = "Send Mail";
      this.butnSendMail.Click += new System.EventHandler(this.butnSendMail_Click);
      // 
      // textSMTPServer
      // 
      this.textSMTPServer.Location = new System.Drawing.Point(104, 80);
      this.textSMTPServer.Name = "textSMTPServer";
      this.textSMTPServer.Size = new System.Drawing.Size(200, 20);
      this.textSMTPServer.TabIndex = 7;
      this.textSMTPServer.Text = "";
      // 
      // textSubject
      // 
      this.textSubject.Location = new System.Drawing.Point(104, 56);
      this.textSubject.Name = "textSubject";
      this.textSubject.Size = new System.Drawing.Size(200, 20);
      this.textSubject.TabIndex = 6;
      this.textSubject.Text = "";
      // 
      // textTo
      // 
      this.textTo.Location = new System.Drawing.Point(104, 32);
      this.textTo.Name = "textTo";
      this.textTo.Size = new System.Drawing.Size(200, 20);
      this.textTo.TabIndex = 5;
      this.textTo.Text = "";
      // 
      // textFrom
      // 
      this.textFrom.Location = new System.Drawing.Point(104, 8);
      this.textFrom.Name = "textFrom";
      this.textFrom.Size = new System.Drawing.Size(200, 20);
      this.textFrom.TabIndex = 4;
      this.textFrom.Text = "";
      // 
      // label4
      // 
      this.label4.Location = new System.Drawing.Point(16, 80);
      this.label4.Name = "label4";
      this.label4.Size = new System.Drawing.Size(88, 16);
      this.label4.TabIndex = 3;
      this.label4.Text = "SMTP Server:";
      // 
      // label3
      // 
      this.label3.Location = new System.Drawing.Point(16, 56);
      this.label3.Name = "label3";
      this.label3.Size = new System.Drawing.Size(72, 16);
      this.label3.TabIndex = 2;
      this.label3.Text = "Subject:";
      // 
      // label2
      // 
      this.label2.Location = new System.Drawing.Point(16, 32);
      this.label2.Name = "label2";
      this.label2.Size = new System.Drawing.Size(72, 16);
      this.label2.TabIndex = 1;
      this.label2.Text = "To:";
      // 
      // label1
      // 
      this.label1.Location = new System.Drawing.Point(16, 8);
      this.label1.Name = "label1";
      this.label1.Size = new System.Drawing.Size(72, 23);
      this.label1.TabIndex = 0;
      this.label1.Text = "From:";
      // 
      // textMsg
      // 
      this.textMsg.Dock = System.Windows.Forms.DockStyle.Fill;
      this.textMsg.Location = new System.Drawing.Point(0, 112);
      this.textMsg.Multiline = true;
      this.textMsg.Name = "textMsg";
      this.textMsg.Size = new System.Drawing.Size(408, 298);
      this.textMsg.TabIndex = 1;
      this.textMsg.Text = "<Type the message you want to send here>";
      // 
      // lboxStatus
      // 
      this.lboxStatus.Dock = System.Windows.Forms.DockStyle.Bottom;
      this.lboxStatus.Location = new System.Drawing.Point(0, 302);
      this.lboxStatus.Name = "lboxStatus";
      this.lboxStatus.Size = new System.Drawing.Size(408, 108);
      this.lboxStatus.TabIndex = 2;
      // 
      // Form1
      // 
      this.AcceptButton = this.butnSendMail;
      this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
      this.ClientSize = new System.Drawing.Size(408, 410);
      this.Controls.Add(this.lboxStatus);
      this.Controls.Add(this.textMsg);
      this.Controls.Add(this.panel1);
      this.MaximizeBox = false;
      this.Name = "Form1";
      this.Text = "Form1";
      this.panel1.ResumeLayout(false);
      this.ResumeLayout(false);

    }
		#endregion

		[STAThread]
		static void Main() {
			Application.Run(new Form1());
		}

    private void Status(string AMessage) {
      lboxStatus.Items.Add(AMessage);
      // Allow the listbox to repaint
      Application.DoEvents();
      Application.DoEvents();
      Application.DoEvents();
    }

    private void SMTPStatus(object aSender, Status aStatus, string aText) {
      Status(aText);
    }

    private void butnSendMail_Click(object sender, System.EventArgs e)  {
      butnSendMail.Enabled = false; 
      try {
        Indy.Sockets.Message LMsg = new Indy.Sockets.Message();
        LMsg.From.Text = textFrom.Text.Trim();
        LMsg.Recipients.Add().Text = textTo.Text.Trim();
        LMsg.Subject = textSubject.Text.Trim();
        LMsg.Body.Text = textMsg.Text;

        // Attachment example
        // new AttachmentFile(LMsg.MessageParts, @"c:\temp\Hydroponics.txt");

        SMTP LSMTP = new SMTP();
        LSMTP.OnStatus += new Indy.Sockets.TIdStatusEvent(SMTPStatus);
        LSMTP.Host = textSMTPServer.Text.Trim();
        LSMTP.Connect();
        try {
          LSMTP.Send(LMsg);
          Status("Completed");
        }
        finally {
          LSMTP.Disconnect();
        }
      }
      finally {
        butnSendMail.Enabled = true;
      }
    }
	}
}
