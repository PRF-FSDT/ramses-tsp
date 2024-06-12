import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;

@versioned(Versions)
@service({
  title: "RAMSES",
})

namespace RamsesService;

enum Versions {
  v1,
  dev,
}

using TypeSpec.Http;
using TypeSpec.Rest;


//RESPONSES:
@error
model Error {
  code: int32;
  message: string;
}


//MODELS:
model Order {
  @key id: string;
  name: string;
  client_no: string;
  client_name: string;
  project_manager: string;
  status: string;
  @added(Versions.dev) ext_created_at: offsetDateTime;
}

model OrderAttachment {
  @key id: string;
  order_no: string;
  type: string;
  path: string;
}

//TODO: extend
model OrderCompositionLine {
  @key id: uint64;
  order_no: string;
}

//TODO: extend
model AdditionalPurchaseLine {
  @key id: uint64;
  order_no: string;
}

model OrderMaterial {
  @key id: string;
  order_no: string;
  material_no: string;
  material_name: string;
  brutto_qty_m2: float32;
  netto_qty_m2: float32;
  orderMaterialItems: OrderMaterialItem[];
}

model OrderMaterialItem {
  @key id: string;
  order_no: string;
  material_no: string;
  item_no: string;
  qty_calculated: uint16;
  user_qty: uint16;
}

model SyncedOrder {
  @key id: string;
  name: string;
  client_no: string;
  client_name: string;
  project_manager: string;
}


//API
//ORDER MANAGER
//Model: Orders
@route("/order-manager/orders")
@tag("Orders")
interface Orders {
  @get list(): Order[] | Error;
  @get read(@path id: string): Order | Error;
  @patch @route("{id}") update(...Order): Order | Error;

  //attachments
  @route("{id}/attachments") @get getAttachments(@path id:string): OrderAttachment[] | Error;
  @route("{id}/attachments") @post postAttachments(@path id:string): void | Error;

  //composition lines
  @route("{id}/composition-lines") @get getCompositionLines(@path id:string): OrderCompositionLine[] | Error;

  //additional purch lines
  @route("{id}/additional-purchase-lines") @get getAdditionalPurchLines(@path id:string): AdditionalPurchaseLine[] | Error;
  @route("{id}/additional-purchase-lines") @post postAdditionalPurchLines(@path id:string): void | Error;
  
  //order materials
  @route("{id}/order-materials") @get getOrderMaterials(@path id:string): OrderMaterial[] | Error;

  //actions
  @route("import") @post postImport(
    order_id: string, 
    delivery_date?: offsetDateTime, 
    @minValue(0) @maxValue(50) prod_duration_in_days?: uint8
  ): string | Error;

  //TODO: define this action
  @route("{id}/push-to-erp") @post postToErp(@path id: string): string | Error;
}

//Model: SyncedOrder
@route("/order-manager/importable-orders")
@tag("Importable Orders")
interface ImportableOrders {
  @get list(): SyncedOrder[] | Error;
  //@route("{/") @get analyze(@path id: string): string | Error;
}

//Model: OrderAttachment
@route("/order-manager/attachments")
@tag("Attachments")
interface OrderAttachments {
  @get read(@path id: string): OrderAttachment | Error; //TODO: also return file contents
  @delete delete(@path id: string): void | Error;
}

//Model: OrderCompositionLine
@route("/order-manager/composition-lines")
@tag("Composition Lines")
interface OrderCompositionLines {
  @patch @route("{id}") update(...OrderCompositionLine): OrderCompositionLine | Error;
}

//Model: AdditionalPurchaseLine
@route("/order-manager/additional-purchase-lines")
@tag("Additional Purchase Lines")
interface AdditionalPurchaseLines {
  @patch @route("{id}") update(...AdditionalPurchaseLine): AdditionalPurchaseLine | Error;
  @delete delete(@path id: string): void | Error;
}

//Model: OrderMaterialItem
@route("/order-manager/order-material-items")
@tag("Order Material Items")
interface OrderMaterialItems {
  @patch @route("{id}") update(...OrderMaterialItem): OrderMaterialItem | Error;
}



// Example API resource:
// @route("/widgets")
// @tag("Widgets")
// interface Widgets {
//   @get list(): Widget[] | Error;
//   @get read(@path id: string): Widget | Error;
//   @post create(...Widget): Widget | Error;
//   @patch update(...Widget): Widget | Error;
//   @delete delete(@path id: string): void | Error;
//   @route("{id}/analyze") @post analyze(@path id: string): string | Error;
// }
