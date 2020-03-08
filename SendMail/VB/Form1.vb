Imports Indy.Sockets

Public Class Form1
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
Friend WithEvents lboxStatus As System.Windows.Forms.ListBox
Friend WithEvents panel1 As System.Windows.Forms.Panel
Friend WithEvents butnSendMail As System.Windows.Forms.Button
Friend WithEvents textSMTPServer As System.Windows.Forms.TextBox
Friend WithEvents textSubject As System.Windows.Forms.TextBox
Friend WithEvents textTo As System.Windows.Forms.TextBox
Friend WithEvents textFrom As System.Windows.Forms.TextBox
Friend WithEvents label4 As System.Windows.Forms.Label
Friend WithEvents label3 As System.Windows.Forms.Label
Friend WithEvents label2 As System.Windows.Forms.Label
Friend WithEvents label1 As System.Windows.Forms.Label
Friend WithEvents textMsg As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
Me.lboxStatus = New System.Windows.Forms.ListBox
Me.panel1 = New System.Windows.Forms.Panel
Me.butnSendMail = New System.Windows.Forms.Button
Me.textSMTPServer = New System.Windows.Forms.TextBox
Me.textSubject = New System.Windows.Forms.TextBox
Me.textTo = New System.Windows.Forms.TextBox
Me.textFrom = New System.Windows.Forms.TextBox
Me.label4 = New System.Windows.Forms.Label
Me.label3 = New System.Windows.Forms.Label
Me.label2 = New System.Windows.Forms.Label
Me.label1 = New System.Windows.Forms.Label
Me.textMsg = New System.Windows.Forms.TextBox
Me.panel1.SuspendLayout()
Me.SuspendLayout()
'
'lboxStatus
'
Me.lboxStatus.Dock = System.Windows.Forms.DockStyle.Bottom
Me.lboxStatus.Location = New System.Drawing.Point(0, 274)
Me.lboxStatus.Name = "lboxStatus"
Me.lboxStatus.Size = New System.Drawing.Size(408, 108)
Me.lboxStatus.TabIndex = 5
'
'panel1
'
Me.panel1.Controls.Add(Me.butnSendMail)
Me.panel1.Controls.Add(Me.textSMTPServer)
Me.panel1.Controls.Add(Me.textSubject)
Me.panel1.Controls.Add(Me.textTo)
Me.panel1.Controls.Add(Me.textFrom)
Me.panel1.Controls.Add(Me.label4)
Me.panel1.Controls.Add(Me.label3)
Me.panel1.Controls.Add(Me.label2)
Me.panel1.Controls.Add(Me.label1)
Me.panel1.Dock = System.Windows.Forms.DockStyle.Top
Me.panel1.Location = New System.Drawing.Point(0, 0)
Me.panel1.Name = "panel1"
Me.panel1.Size = New System.Drawing.Size(408, 112)
Me.panel1.TabIndex = 3
'
'butnSendMail
'
Me.butnSendMail.Location = New System.Drawing.Point(328, 8)
Me.butnSendMail.Name = "butnSendMail"
Me.butnSendMail.TabIndex = 8
Me.butnSendMail.Text = "Send Mail"
'
'textSMTPServer
'
Me.textSMTPServer.Location = New System.Drawing.Point(104, 80)
Me.textSMTPServer.Name = "textSMTPServer"
Me.textSMTPServer.Size = New System.Drawing.Size(200, 20)
Me.textSMTPServer.TabIndex = 7
Me.textSMTPServer.Text = ""
'
'textSubject
'
Me.textSubject.Location = New System.Drawing.Point(104, 56)
Me.textSubject.Name = "textSubject"
Me.textSubject.Size = New System.Drawing.Size(200, 20)
Me.textSubject.TabIndex = 6
Me.textSubject.Text = ""
'
'textTo
'
Me.textTo.Location = New System.Drawing.Point(104, 32)
Me.textTo.Name = "textTo"
Me.textTo.Size = New System.Drawing.Size(200, 20)
Me.textTo.TabIndex = 5
Me.textTo.Text = ""
'
'textFrom
'
Me.textFrom.Location = New System.Drawing.Point(104, 8)
Me.textFrom.Name = "textFrom"
Me.textFrom.Size = New System.Drawing.Size(200, 20)
Me.textFrom.TabIndex = 4
Me.textFrom.Text = ""
'
'label4
'
Me.label4.Location = New System.Drawing.Point(16, 80)
Me.label4.Name = "label4"
Me.label4.Size = New System.Drawing.Size(88, 16)
Me.label4.TabIndex = 3
Me.label4.Text = "SMTP Server:"
'
'label3
'
Me.label3.Location = New System.Drawing.Point(16, 56)
Me.label3.Name = "label3"
Me.label3.Size = New System.Drawing.Size(72, 16)
Me.label3.TabIndex = 2
Me.label3.Text = "Subject:"
'
'label2
'
Me.label2.Location = New System.Drawing.Point(16, 32)
Me.label2.Name = "label2"
Me.label2.Size = New System.Drawing.Size(72, 16)
Me.label2.TabIndex = 1
Me.label2.Text = "To:"
'
'label1
'
Me.label1.Location = New System.Drawing.Point(16, 8)
Me.label1.Name = "label1"
Me.label1.Size = New System.Drawing.Size(72, 23)
Me.label1.TabIndex = 0
Me.label1.Text = "From:"
'
'textMsg
'
Me.textMsg.Location = New System.Drawing.Point(0, 112)
Me.textMsg.Multiline = True
Me.textMsg.Name = "textMsg"
Me.textMsg.Size = New System.Drawing.Size(408, 298)
Me.textMsg.TabIndex = 4
Me.textMsg.Text = "<Type the message you want to send here>"
'
'Form1
'
Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
Me.ClientSize = New System.Drawing.Size(408, 382)
Me.Controls.Add(Me.lboxStatus)
Me.Controls.Add(Me.panel1)
Me.Controls.Add(Me.textMsg)
Me.Name = "Form1"
Me.Text = "Form1"
Me.panel1.ResumeLayout(False)
Me.ResumeLayout(False)

    End Sub

#End Region

Private Sub Status(ByVal aMessage As String)
  lboxStatus.Items.Add(aMessage)
  ' Allow the listbox to repaint
  Application.DoEvents()
  Application.DoEvents()
  Application.DoEvents()
End Sub

Private Sub SMTPStatus(ByVal aSender As Object, ByVal aStatus As Status, ByVal aText As String)
  Status(aText)
End Sub

Private Sub butnSendMail_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles butnSendMail.Click
  butnSendMail.Enabled = False
  Try
    Dim LMsg As New Indy.Sockets.Message
    LMsg.From.Text = textFrom.Text.Trim
    LMsg.Recipients.Add.Text = textTo.Text.Trim
    LMsg.Subject = textSubject.Text.Trim
    LMsg.Body.Text = textMsg.Text

    ' Attachment example
    ' Dim xAttachment As New AttachmentFile(LMsg.MessageParts, "c:\temp\Hydroponics.txt")

    Dim LSMTP As New SMTP
    AddHandler LSMTP.OnStatus, AddressOf SMTPStatus
    LSMTP.Host = textSMTPServer.Text.Trim
    LSMTP.Connect()
    Try
      LSMTP.Send(LMsg)
      'Status("Completed")
    Finally
      LSMTP.Disconnect()
    End Try
  Finally
    butnSendMail.Enabled = True
  End Try
End Sub

End Class
