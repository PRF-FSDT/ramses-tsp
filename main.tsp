import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";
import "./models.tsp";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

@versioned(Versions)
@service({
  title: "RAMSES",
})

namespace RamsesService;


//API

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

//ORDER MANAGER

@tag("Auth")
interface Auth {
  @route("login") @post postLogin(email: string, password: string, device_name: string): LoginResponse | Error;
  @route("logout") @post postLogout(): LogoutResponse | Error;
  @route("me") @get getMe(): MeResponse | Error;
}

//Model: Orders
@route("/order-manager/orders")
@tag("Orders")
interface Orders {
  @get list(@query query: OrderIndexFilterRequest): PaginatedResponse<Order> | Error;
  @get read(@path id: string): Order | Error;
  @patch @route("{id}") update(...Order): SuccessResponse | Error;

  //attachments
  @route("{id}/attachments") @get getAttachments(@path id:string, @query query: PaginatedRequest): PaginatedResponse<OrderAttachment> | Error;
  @route("{id}/attachments") @post postAttachments(@path id:string): void | SuccessResponse | Error;

  //composition lines
  @route("{id}/composition-lines") @get getCompositionLines(@path id:string, @query query: OrderCompositionLineRequest): PaginatedResponse<OrderCompositionLine> | Error;

  //additional purch lines
  @route("{id}/additional-purchase-lines") @get getAdditionalPurchLines(@path id:string, @query query: PaginatedSortableRequest): PaginatedResponse<AdditionalPurchaseLine> | Error;
  @route("{id}/additional-purchase-lines") @post postAdditionalPurchLines(@path id: string, material_no: string, name: string, brand?: string, type?: string, qty: numeric, uom: string, length_mm?: integer, width_mm?: integer, height_mm?: integer): void | SuccessResponse | Error;
  
  //order materials
  @route("{id}/order-materials") @get getOrderMaterials(@path id:string, @query query: OrderMaterialIndexFilterRequest): PaginatedResponse<OrderMaterial> | Error;
  @route("{id}/order-materials-csv") @get getOrderMaterialsCsv(@path id:string, @query query: OrderMaterialCsvRequest): StreamedCsvResponse | Error;

  //actions
  @route("import") @post postImport(
    synced_order_id: string, 
    delivery_date?: offsetDateTime, 
    @minValue(0) @maxValue(50) prod_duration_days?: uint8
  ): SuccessResponse | Error;

  //TODO: define this action
  @route("{id}/push-to-erp") @post postToErp(@path id: string): string | Error;
}

//Model: SyncedOrder
@route("/order-manager/importable-orders")
@tag("Importable Orders")
interface ImportableOrders {
  @get list(@query query: PaginatedRequest): PaginatedResponse<SyncedOrder> | Error;
  //@route("{/") @get analyze(@path id: string): string | Error;
}

//Model: OrderAttachment
@route("/order-manager/attachments")
@tag("Attachments")
interface OrderAttachments {
  @get read(@path id: string): OrderAttachment | Error; //TODO: also return file contents
  @delete delete(@path id: string): void | SuccessResponse | Error;
}

//Model: OrderCompositionLine
@route("/order-manager/composition-lines")
@tag("Composition Lines")
interface OrderCompositionLines {
  @patch @route("{id}") update(@path id: string, is_outsourced: boolean): SuccessResponse | Error;
}

//Model: AdditionalPurchaseLine
@route("/order-manager/additional-purchase-lines")
@tag("Additional Purchase Lines")
interface AdditionalPurchaseLines {
  @patch @route("{id}") update(@path id: string, material_no?: string, name?: string, brand?: string, type?: string, qty?: numeric, uom?: string, length_mm?: integer, width_mm?: integer, height_mm?: integer): SuccessResponse | Error;
  @delete delete(@path id: string): void | SuccessResponse | Error;
}

//Model: OrderMaterialItem
@route("/order-manager/order-material-items")
@tag("Order Material Items")
interface OrderMaterialItems {
  @patch @route("{id}") update(@path id: string, qty: numeric): SuccessResponse | Error;
}

