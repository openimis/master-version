<%-- Copyright (c) 2016-2017 Swiss Agency for Development and Cooperation (SDC)

The program users must agree to the following terms:

Copyright notices
This program is free software: you can redistribute it and/or modify it under the terms of the GNU AGPL v3 License as published by the 
Free Software Foundation, version 3 of the License.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU AGPL v3 License for more details www.gnu.org.

Disclaimer of Warranty
There is no warranty for the program, to the extent permitted by applicable law; except when otherwise stated in writing the copyright 
holders and/or other parties provide the program "as is" without warranty of any kind, either expressed or implied, including, but not 
limited to, the implied warranties of merchantability and fitness for a particular purpose. The entire risk as to the quality and 
performance of the program is with you. Should the program prove defective, you assume the cost of all necessary servicing, repair or correction.

Limitation of Liability 
In no event unless required by applicable law or agreed to in writing will any copyright holder, or any other party who modifies and/or 
conveys the program as permitted above, be liable to you for damages, including any general, special, incidental or consequential damages 
arising out of the use or inability to use the program (including but not limited to loss of data or data being rendered inaccurate or losses 
sustained by you or third parties or a failure of the program to operate with any other programs), even if such holder or other party has been 
advised of the possibility of such damages.

In case of dispute arising out or in relation to the use of the program, it is subject to the public law of Switzerland. The place of jurisdiction is Berne.--%>
 <%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/IMIS.Master" CodeBehind="UploadICD.aspx.vb" Inherits="IMIS.UploadICD" Title='<%$ Resources:Resource,L_UPLOADICD %>'  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="contenthead" ContentPlaceHolderID="head" runat="server">
<script type="text/javascript" language="javascript">

    $(document).ready(function() {
    $("#<%=btnUpload.ClientID %>").click(function() {
    htmlMsgUpload = '<%= imisgen.getMessage("M_AREYOUSUREUPLOADICDLIST", True ) %>';

    popup.acceptBTN_Text = '<%=imisgen.getMessage("L_YES", True)%>';
    popup.rejectBTN_Text = '<%=imisgen.getMessage("L_NO", True ) %>';
    popup.confirm(htmlMsgUpload, UploadIDCFn);
    return false;
        });
    });

    function UploadIDCFn(btn) {
        if (btn == "ok") {
            __doPostBack("<%=btnUpload.ClientID %>", "");
        } else if (btn == "cancel") {
        return false;
        }
    }
</script>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="Body" Runat="Server">

<div class="divBody" >  
    
         <asp:FileUpload ID="FileUpload1" runat="server" />
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                    ControlToValidate="FileUpload1" ErrorMessage="M_PLEASESELECTTHEFILE" 
                    SetFocusOnError="True" Text='<%$ Resources:Resource, M_PLEASESELECTTHEFILE %>' ValidationGroup="Upload"></asp:RequiredFieldValidator>
                
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ErrorMessage="Select only .isf File" ControlToValidate="FileUpload1" Text='<%$ Resources:Resource, M_SELECTONLYTXTFILE %>'
                    SetFocusOnError="true" ValidationGroup="Upload" 
                    ValidationExpression="^.+\.(txt)$" ></asp:RegularExpressionValidator>
                
                
        &nbsp;<asp:CheckBox ID="chkDelete" runat="server" 
             Text="<%$ Resources:Resource, L_PERFORMDELETION %>" CssClass="checkbox" />
                
                
        <div align="center" style="padding:100px" >
        
        </div>
 </div>

         <asp:Panel ID="Panel1" runat="server"   CssClass="panelbuttons" >
        <table width="100%" cellpadding="10 10 10 10">
             <tr>
                    
                     <td  align="left">
                    <%--<asp:Button 
                        ID="B_ADD" 
                        runat="server" 
                        Text='<%$ Resources:Resource,B_ADD%>'
                          />--%>
                         <asp:Button ID="btnUpload" runat="server" 
                             Text='<%$ Resources:Resource,B_UPLOAD%>' ValidationGroup="Upload" />
                    </td>
                    <td align="center">
                   <%-- <asp:Button 
                        
                        ID="B_EDIT" 
                        runat="server" 
                        Text='<%$ Resources:Resource,B_EDIT%>'
                        ValidationGroup="check"  />--%>
                    </td>
                       <td align="right">
                 <asp:Button 
                    
                    ID="B_CANCEL" 
                    runat="server" 
                    Text='<%$ Resources:Resource,B_CANCEL%>'
                      />
                    </td>
                </tr>
            </table>             
         </asp:Panel> 
</asp:Content>

<asp:Content ID="footer"  ContentPlaceHolderID ="Footer" runat="server" >
<asp:Label ID="lblMsg" runat="server"></asp:Label>

</asp:Content>
