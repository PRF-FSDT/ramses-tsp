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
  @route("me") @get getMe(): string | Error;
}

//Model: Orders
@route("/order-manager/orders")
@tag("Orders")
interface Orders {
  @get list(@query query: FilterRequest): PaginatedResponse<Order> | Error;
  @get read(@path id: string): Order | Error;
  @patch @route("{id}") update(...Order): Order | Error;

  //attachments
  @route("{id}/attachments") @get getAttachments(@path id:string, @query query: FilterRequest): PaginatedResponse<OrderAttachment> | Error;
  @route("{id}/attachments") @post postAttachments(@path id:string): void | Error;

  //composition lines
  @route("{id}/composition-lines") @get getCompositionLines(@path id:string, @query query: FilterRequest): PaginatedResponse<OrderCompositionLine> | Error;

  //additional purch lines
  @route("{id}/additional-purchase-lines") @get getAdditionalPurchLines(@path id:string, @query query: FilterRequest): PaginatedResponse<AdditionalPurchaseLine> | Error;
  @route("{id}/additional-purchase-lines") @post postAdditionalPurchLines(@path id:string): void | Error;
  
  //order materials
  @route("{id}/order-materials") @get getOrderMaterials(@path id:string, @query query: FilterRequest): PaginatedResponse<OrderMaterial> | Error;

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
  @get list(@query query: FilterRequest): PaginatedResponse<SyncedOrder> | Error;
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

