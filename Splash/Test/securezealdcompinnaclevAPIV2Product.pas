
{*********************************************************************************************************}
{                                                                                                         }
{                                            XML Data Binding                                             }
{                                                                                                         }
{         Generated on: 27/05/2014 8:35:38 p.m.                                                           }
{       Generated from: https://secure.zeald.com/pinnaclev/API/V2/Product.xsd?_key=323bdAD5Bb26Aeb6e0d6   }
{   Settings stored in: C:\Richard\Delphi\Splash\Test\Product                                             }
{                                                                                                         }
{*********************************************************************************************************}

unit securezealdcompinnaclevAPIV2Product;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLResultSet = interface;
  IXMLResultSet_Product = interface;

{ IXMLResultSet }

  IXMLResultSet = interface(IXMLNodeCollection)
    ['{FA31C26F-F293-417A-981B-4AFE715649BC}']
    { Property Accessors }
    function Get_StartResultIndex: Integer;
    function Get_TotalResults: Integer;
    function Get_TotalResultsReturned: Integer;
    function Get_Product(Index: Integer): IXMLResultSet_Product;
    procedure Set_StartResultIndex(Value: Integer);
    procedure Set_TotalResults(Value: Integer);
    procedure Set_TotalResultsReturned(Value: Integer);
    { Methods & Properties }
    function Add: IXMLResultSet_Product;
    function Insert(const Index: Integer): IXMLResultSet_Product;
    property StartResultIndex: Integer read Get_StartResultIndex write Set_StartResultIndex;
    property TotalResults: Integer read Get_TotalResults write Set_TotalResults;
    property TotalResultsReturned: Integer read Get_TotalResultsReturned write Set_TotalResultsReturned;
    property Product[Index: Integer]: IXMLResultSet_Product read Get_Product; default;
  end;

{ IXMLResultSet_Product }

  IXMLResultSet_Product = interface(IXMLNode)
    ['{0DCFA28F-8B30-4A93-AEAA-5AE09360E8EC}']
    { Property Accessors }
    function Get_Href: UnicodeString;
    function Get_Id: UnicodeString;
    function Get_Access_control: Boolean;
    function Get_Advanced_pricing: Boolean;
    function Get_Comment: UnicodeString;
    function Get_Custom_data1: UnicodeString;
    function Get_Custom_data2: UnicodeString;
    function Get_Custom_data3: UnicodeString;
    function Get_Custom_data4: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_Extended: UnicodeString;
    function Get_Image: UnicodeString;
    function Get_Image_large: UnicodeString;
    function Get_Inactive: Boolean;
    function Get_Last_modified: UnicodeString;
    function Get_Meta_desc: UnicodeString;
    function Get_Meta_key_words: UnicodeString;
    function Get_Meta_page_title: UnicodeString;
    function Get_Nontaxable: UnicodeString;
    function Get_Option_type: UnicodeString;
    function Get_Options_advanced: Boolean;
    function Get_Price: UnicodeString;
    function Get_Priority: UnicodeString;
    function Get_Product_type: UnicodeString;
    function Get_Sku: UnicodeString;
    function Get_Supplier: UnicodeString;
    function Get_Thumb: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Url_override: UnicodeString;
    function Get_Weight: UnicodeString;
    function Get_Wholesale: UnicodeString;
    procedure Set_Href(Value: UnicodeString);
    procedure Set_Id(Value: UnicodeString);
    procedure Set_Access_control(Value: Boolean);
    procedure Set_Advanced_pricing(Value: Boolean);
    procedure Set_Comment(Value: UnicodeString);
    procedure Set_Custom_data1(Value: UnicodeString);
    procedure Set_Custom_data2(Value: UnicodeString);
    procedure Set_Custom_data3(Value: UnicodeString);
    procedure Set_Custom_data4(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_Extended(Value: UnicodeString);
    procedure Set_Image(Value: UnicodeString);
    procedure Set_Image_large(Value: UnicodeString);
    procedure Set_Inactive(Value: Boolean);
    procedure Set_Last_modified(Value: UnicodeString);
    procedure Set_Meta_desc(Value: UnicodeString);
    procedure Set_Meta_key_words(Value: UnicodeString);
    procedure Set_Meta_page_title(Value: UnicodeString);
    procedure Set_Nontaxable(Value: UnicodeString);
    procedure Set_Option_type(Value: UnicodeString);
    procedure Set_Options_advanced(Value: Boolean);
    procedure Set_Price(Value: UnicodeString);
    procedure Set_Priority(Value: UnicodeString);
    procedure Set_Product_type(Value: UnicodeString);
    procedure Set_Sku(Value: UnicodeString);
    procedure Set_Supplier(Value: UnicodeString);
    procedure Set_Thumb(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Url_override(Value: UnicodeString);
    procedure Set_Weight(Value: UnicodeString);
    procedure Set_Wholesale(Value: UnicodeString);
    { Methods & Properties }
    property Href: UnicodeString read Get_Href write Set_Href;
    property Id: UnicodeString read Get_Id write Set_Id;
    property Access_control: Boolean read Get_Access_control write Set_Access_control;
    property Advanced_pricing: Boolean read Get_Advanced_pricing write Set_Advanced_pricing;
    property Comment: UnicodeString read Get_Comment write Set_Comment;
    property Custom_data1: UnicodeString read Get_Custom_data1 write Set_Custom_data1;
    property Custom_data2: UnicodeString read Get_Custom_data2 write Set_Custom_data2;
    property Custom_data3: UnicodeString read Get_Custom_data3 write Set_Custom_data3;
    property Custom_data4: UnicodeString read Get_Custom_data4 write Set_Custom_data4;
    property Description: UnicodeString read Get_Description write Set_Description;
    property Extended: UnicodeString read Get_Extended write Set_Extended;
    property Image: UnicodeString read Get_Image write Set_Image;
    property Image_large: UnicodeString read Get_Image_large write Set_Image_large;
    property Inactive: Boolean read Get_Inactive write Set_Inactive;
    property Last_modified: UnicodeString read Get_Last_modified write Set_Last_modified;
    property Meta_desc: UnicodeString read Get_Meta_desc write Set_Meta_desc;
    property Meta_key_words: UnicodeString read Get_Meta_key_words write Set_Meta_key_words;
    property Meta_page_title: UnicodeString read Get_Meta_page_title write Set_Meta_page_title;
    property Nontaxable: UnicodeString read Get_Nontaxable write Set_Nontaxable;
    property Option_type: UnicodeString read Get_Option_type write Set_Option_type;
    property Options_advanced: Boolean read Get_Options_advanced write Set_Options_advanced;
    property Price: UnicodeString read Get_Price write Set_Price;
    property Priority: UnicodeString read Get_Priority write Set_Priority;
    property Product_type: UnicodeString read Get_Product_type write Set_Product_type;
    property Sku: UnicodeString read Get_Sku write Set_Sku;
    property Supplier: UnicodeString read Get_Supplier write Set_Supplier;
    property Thumb: UnicodeString read Get_Thumb write Set_Thumb;
    property Title: UnicodeString read Get_Title write Set_Title;
    property Url_override: UnicodeString read Get_Url_override write Set_Url_override;
    property Weight: UnicodeString read Get_Weight write Set_Weight;
    property Wholesale: UnicodeString read Get_Wholesale write Set_Wholesale;
  end;

{ Forward Decls }

  TXMLResultSet = class;
  TXMLResultSet_Product = class;

{ TXMLResultSet }

  TXMLResultSet = class(TXMLNodeCollection, IXMLResultSet)
  protected
    { IXMLResultSet }
    function Get_StartResultIndex: Integer;
    function Get_TotalResults: Integer;
    function Get_TotalResultsReturned: Integer;
    function Get_Product(Index: Integer): IXMLResultSet_Product;
    procedure Set_StartResultIndex(Value: Integer);
    procedure Set_TotalResults(Value: Integer);
    procedure Set_TotalResultsReturned(Value: Integer);
    function Add: IXMLResultSet_Product;
    function Insert(const Index: Integer): IXMLResultSet_Product;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLResultSet_Product }

  TXMLResultSet_Product = class(TXMLNode, IXMLResultSet_Product)
  protected
    { IXMLResultSet_Product }
    function Get_Href: UnicodeString;
    function Get_Id: UnicodeString;
    function Get_Access_control: Boolean;
    function Get_Advanced_pricing: Boolean;
    function Get_Comment: UnicodeString;
    function Get_Custom_data1: UnicodeString;
    function Get_Custom_data2: UnicodeString;
    function Get_Custom_data3: UnicodeString;
    function Get_Custom_data4: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_Extended: UnicodeString;
    function Get_Image: UnicodeString;
    function Get_Image_large: UnicodeString;
    function Get_Inactive: Boolean;
    function Get_Last_modified: UnicodeString;
    function Get_Meta_desc: UnicodeString;
    function Get_Meta_key_words: UnicodeString;
    function Get_Meta_page_title: UnicodeString;
    function Get_Nontaxable: UnicodeString;
    function Get_Option_type: UnicodeString;
    function Get_Options_advanced: Boolean;
    function Get_Price: UnicodeString;
    function Get_Priority: UnicodeString;
    function Get_Product_type: UnicodeString;
    function Get_Sku: UnicodeString;
    function Get_Supplier: UnicodeString;
    function Get_Thumb: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Url_override: UnicodeString;
    function Get_Weight: UnicodeString;
    function Get_Wholesale: UnicodeString;
    procedure Set_Href(Value: UnicodeString);
    procedure Set_Id(Value: UnicodeString);
    procedure Set_Access_control(Value: Boolean);
    procedure Set_Advanced_pricing(Value: Boolean);
    procedure Set_Comment(Value: UnicodeString);
    procedure Set_Custom_data1(Value: UnicodeString);
    procedure Set_Custom_data2(Value: UnicodeString);
    procedure Set_Custom_data3(Value: UnicodeString);
    procedure Set_Custom_data4(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_Extended(Value: UnicodeString);
    procedure Set_Image(Value: UnicodeString);
    procedure Set_Image_large(Value: UnicodeString);
    procedure Set_Inactive(Value: Boolean);
    procedure Set_Last_modified(Value: UnicodeString);
    procedure Set_Meta_desc(Value: UnicodeString);
    procedure Set_Meta_key_words(Value: UnicodeString);
    procedure Set_Meta_page_title(Value: UnicodeString);
    procedure Set_Nontaxable(Value: UnicodeString);
    procedure Set_Option_type(Value: UnicodeString);
    procedure Set_Options_advanced(Value: Boolean);
    procedure Set_Price(Value: UnicodeString);
    procedure Set_Priority(Value: UnicodeString);
    procedure Set_Product_type(Value: UnicodeString);
    procedure Set_Sku(Value: UnicodeString);
    procedure Set_Supplier(Value: UnicodeString);
    procedure Set_Thumb(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Url_override(Value: UnicodeString);
    procedure Set_Weight(Value: UnicodeString);
    procedure Set_Wholesale(Value: UnicodeString);
  end;

{ Global Functions }

function GetResultSet(Doc: IXMLDocument): IXMLResultSet;
function LoadResultSet(const FileName: string): IXMLResultSet;
function NewResultSet: IXMLResultSet;

const
  TargetNamespace = 'http://www.zeald.com';

implementation

{ Global Functions }

function GetResultSet(Doc: IXMLDocument): IXMLResultSet;
begin
  Result := Doc.GetDocBinding('ResultSet', TXMLResultSet, TargetNamespace) as IXMLResultSet;
end;

function LoadResultSet(const FileName: string): IXMLResultSet;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('ResultSet', TXMLResultSet, TargetNamespace) as IXMLResultSet;
end;

function NewResultSet: IXMLResultSet;
begin
  Result := NewXMLDocument.GetDocBinding('ResultSet', TXMLResultSet, TargetNamespace) as IXMLResultSet;
end;

{ TXMLResultSet }

procedure TXMLResultSet.AfterConstruction;
begin
  RegisterChildNode('Product', TXMLResultSet_Product);
  ItemTag := 'Product';
  ItemInterface := IXMLResultSet_Product;
  inherited;
end;

function TXMLResultSet.Get_StartResultIndex: Integer;
begin
  Result := AttributeNodes['startResultIndex'].NodeValue;
end;

procedure TXMLResultSet.Set_StartResultIndex(Value: Integer);
begin
  SetAttribute('startResultIndex', Value);
end;

function TXMLResultSet.Get_TotalResults: Integer;
begin
  Result := AttributeNodes['totalResults'].NodeValue;
end;

procedure TXMLResultSet.Set_TotalResults(Value: Integer);
begin
  SetAttribute('totalResults', Value);
end;

function TXMLResultSet.Get_TotalResultsReturned: Integer;
begin
  Result := AttributeNodes['totalResultsReturned'].NodeValue;
end;

procedure TXMLResultSet.Set_TotalResultsReturned(Value: Integer);
begin
  SetAttribute('totalResultsReturned', Value);
end;

function TXMLResultSet.Get_Product(Index: Integer): IXMLResultSet_Product;
begin
  Result := List[Index] as IXMLResultSet_Product;
end;

function TXMLResultSet.Add: IXMLResultSet_Product;
begin
  Result := AddItem(-1) as IXMLResultSet_Product;
end;

function TXMLResultSet.Insert(const Index: Integer): IXMLResultSet_Product;
begin
  Result := AddItem(Index) as IXMLResultSet_Product;
end;

{ TXMLResultSet_Product }

function TXMLResultSet_Product.Get_Href: UnicodeString;
begin
  Result := AttributeNodes['href'].Text;
end;

procedure TXMLResultSet_Product.Set_Href(Value: UnicodeString);
begin
  SetAttribute('href', Value);
end;

function TXMLResultSet_Product.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLResultSet_Product.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLResultSet_Product.Get_Access_control: Boolean;
begin
  Result := ChildNodes['access_control'].NodeValue;
end;

procedure TXMLResultSet_Product.Set_Access_control(Value: Boolean);
begin
  ChildNodes['access_control'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Advanced_pricing: Boolean;
begin
  Result := ChildNodes['advanced_pricing'].NodeValue;
end;

procedure TXMLResultSet_Product.Set_Advanced_pricing(Value: Boolean);
begin
  ChildNodes['advanced_pricing'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Comment: UnicodeString;
begin
  Result := ChildNodes['comment'].Text;
end;

procedure TXMLResultSet_Product.Set_Comment(Value: UnicodeString);
begin
  ChildNodes['comment'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Custom_data1: UnicodeString;
begin
  Result := ChildNodes['custom_data1'].Text;
end;

procedure TXMLResultSet_Product.Set_Custom_data1(Value: UnicodeString);
begin
  ChildNodes['custom_data1'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Custom_data2: UnicodeString;
begin
  Result := ChildNodes['custom_data2'].Text;
end;

procedure TXMLResultSet_Product.Set_Custom_data2(Value: UnicodeString);
begin
  ChildNodes['custom_data2'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Custom_data3: UnicodeString;
begin
  Result := ChildNodes['custom_data3'].Text;
end;

procedure TXMLResultSet_Product.Set_Custom_data3(Value: UnicodeString);
begin
  ChildNodes['custom_data3'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Custom_data4: UnicodeString;
begin
  Result := ChildNodes['custom_data4'].Text;
end;

procedure TXMLResultSet_Product.Set_Custom_data4(Value: UnicodeString);
begin
  ChildNodes['custom_data4'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Description: UnicodeString;
begin
  Result := ChildNodes['description'].Text;
end;

procedure TXMLResultSet_Product.Set_Description(Value: UnicodeString);
begin
  ChildNodes['description'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Extended: UnicodeString;
begin
  Result := ChildNodes['extended'].Text;
end;

procedure TXMLResultSet_Product.Set_Extended(Value: UnicodeString);
begin
  ChildNodes['extended'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Image: UnicodeString;
begin
  Result := ChildNodes['image'].Text;
end;

procedure TXMLResultSet_Product.Set_Image(Value: UnicodeString);
begin
  ChildNodes['image'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Image_large: UnicodeString;
begin
  Result := ChildNodes['image_large'].Text;
end;

procedure TXMLResultSet_Product.Set_Image_large(Value: UnicodeString);
begin
  ChildNodes['image_large'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Inactive: Boolean;
begin
  Result := ChildNodes['inactive'].NodeValue;
end;

procedure TXMLResultSet_Product.Set_Inactive(Value: Boolean);
begin
  ChildNodes['inactive'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Last_modified: UnicodeString;
begin
  Result := ChildNodes['last_modified'].Text;
end;

procedure TXMLResultSet_Product.Set_Last_modified(Value: UnicodeString);
begin
  ChildNodes['last_modified'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Meta_desc: UnicodeString;
begin
  Result := ChildNodes['meta_desc'].Text;
end;

procedure TXMLResultSet_Product.Set_Meta_desc(Value: UnicodeString);
begin
  ChildNodes['meta_desc'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Meta_key_words: UnicodeString;
begin
  Result := ChildNodes['meta_key_words'].Text;
end;

procedure TXMLResultSet_Product.Set_Meta_key_words(Value: UnicodeString);
begin
  ChildNodes['meta_key_words'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Meta_page_title: UnicodeString;
begin
  Result := ChildNodes['meta_page_title'].Text;
end;

procedure TXMLResultSet_Product.Set_Meta_page_title(Value: UnicodeString);
begin
  ChildNodes['meta_page_title'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Nontaxable: UnicodeString;
begin
  Result := ChildNodes['nontaxable'].Text;
end;

procedure TXMLResultSet_Product.Set_Nontaxable(Value: UnicodeString);
begin
  ChildNodes['nontaxable'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Option_type: UnicodeString;
begin
  Result := ChildNodes['option_type'].Text;
end;

procedure TXMLResultSet_Product.Set_Option_type(Value: UnicodeString);
begin
  ChildNodes['option_type'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Options_advanced: Boolean;
begin
  Result := ChildNodes['options_advanced'].NodeValue;
end;

procedure TXMLResultSet_Product.Set_Options_advanced(Value: Boolean);
begin
  ChildNodes['options_advanced'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Price: UnicodeString;
begin
  Result := ChildNodes['price'].Text;
end;

procedure TXMLResultSet_Product.Set_Price(Value: UnicodeString);
begin
  ChildNodes['price'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Priority: UnicodeString;
begin
  Result := ChildNodes['priority'].Text;
end;

procedure TXMLResultSet_Product.Set_Priority(Value: UnicodeString);
begin
  ChildNodes['priority'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Product_type: UnicodeString;
begin
  Result := ChildNodes['product_type'].Text;
end;

procedure TXMLResultSet_Product.Set_Product_type(Value: UnicodeString);
begin
  ChildNodes['product_type'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Sku: UnicodeString;
begin
  Result := ChildNodes['sku'].Text;
end;

procedure TXMLResultSet_Product.Set_Sku(Value: UnicodeString);
begin
  ChildNodes['sku'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Supplier: UnicodeString;
begin
  Result := ChildNodes['supplier'].Text;
end;

procedure TXMLResultSet_Product.Set_Supplier(Value: UnicodeString);
begin
  ChildNodes['supplier'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Thumb: UnicodeString;
begin
  Result := ChildNodes['thumb'].Text;
end;

procedure TXMLResultSet_Product.Set_Thumb(Value: UnicodeString);
begin
  ChildNodes['thumb'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Title: UnicodeString;
begin
  Result := ChildNodes['title'].Text;
end;

procedure TXMLResultSet_Product.Set_Title(Value: UnicodeString);
begin
  ChildNodes['title'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Url_override: UnicodeString;
begin
  Result := ChildNodes['url_override'].Text;
end;

procedure TXMLResultSet_Product.Set_Url_override(Value: UnicodeString);
begin
  ChildNodes['url_override'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Weight: UnicodeString;
begin
  Result := ChildNodes['weight'].Text;
end;

procedure TXMLResultSet_Product.Set_Weight(Value: UnicodeString);
begin
  ChildNodes['weight'].NodeValue := Value;
end;

function TXMLResultSet_Product.Get_Wholesale: UnicodeString;
begin
  Result := ChildNodes['wholesale'].Text;
end;

procedure TXMLResultSet_Product.Set_Wholesale(Value: UnicodeString);
begin
  ChildNodes['wholesale'].NodeValue := Value;
end;

end.