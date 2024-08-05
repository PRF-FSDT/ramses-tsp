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
  @route("{id}/attachments") @get getAttachments(@path id: string, @query query: PaginatedRequest): PaginatedResponse<OrderAttachment> | Error;
  @route("{id}/attachments") @post postAttachments(@path id: string): void | SuccessResponse | Error;

  //composition lines
  @route("{id}/composition-lines") @get getCompositionLines(
    @path id: string,
    @query query: OrderCompositionLineRequest,
  ): PaginatedResponse<OrderCompositionLine> | Error;

  //order tasks
  @route("{id}/order-tasks") @get getOrderTasks(@path id: string, @query query: OrderTaskFilterRequest): PaginatedResponse<OrderTask> | Error;
  @post @route("{id}/order-tasks/plan") planOrderTasks(@path id: string, @body ToPlanTasks: ToPlanTaskBody[]): CreatedResponse<ToPlanTaskBody[]>| Error;
  //additional purch lines
  @route("{id}/additional-purchase-lines") @get getAdditionalPurchLines(
    @path id: string,
    @query query: PaginatedSortableRequest,
  ): PaginatedResponse<AdditionalPurchaseLine> | Error;
  @route("{id}/additional-purchase-lines") @post postAdditionalPurchLines(
    @path id: string,
    material_no: string,
    name: string,
    brand?: string,
    type?: string,
    qty: numeric,
    uom: string,
    length_mm?: integer,
    width_mm?: integer,
    height_mm?: integer,
  ): void | SuccessResponse | Error;

  //order materials
  @route("{id}/order-materials") @get getOrderMaterials(
    @path id: string,
    @query query: OrderMaterialIndexFilterRequest,
  ): PaginatedResponse<OrderMaterial> | Error;
  @route("{id}/order-materials-csv") @get getOrderMaterialsCsv(@path id: string, @query query: OrderMaterialCsvRequest): StreamedCsvResponse | Error;

  //actions
  @route("import") @post postImport(@body OrderImportBody: OrderImportBody): OrderImportResponse | Error;

  //TODO: define this action
  @route("{id}/push-to-erp") @post postToErp(@path id: string): string | Error;

  @route("/unplanned") @get getUnplanned(@query query: PaginatedRequest): PaginatedResponse<Order> | Error;
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
  @patch @route("{id}") update(
    @path id: string,
    material_no?: string,
    name?: string,
    brand?: string,
    type?: string,
    qty?: numeric,
    uom?: string,
    length_mm?: integer,
    width_mm?: integer,
    height_mm?: integer,
  ): SuccessResponse | Error;
  @delete delete(@path id: string): void | SuccessResponse | Error;
}

//Model: OrderMaterialItem
@route("/order-manager/order-material-items")
@tag("Order Material Items")
interface OrderMaterialItems {
  @patch @route("{id}") update(@path id: string, qty: numeric): SuccessResponse | Error;
}

//Model: OrderTask
@route("/order-manager/order-tasks")
@tag("Order Tasks")
interface OrderTasks {
  @post @route("/") post(
    order_no: string,
    type: "preparation" | "finalisation",
    title: string,
    should_be_planned: boolean,
    is_required_for_production: boolean,
    is_external: boolean,
    is_finished: boolean,
    dependant_on: Array<integer>,
  ): void | SuccessResponse | Error;
  @patch @route("{id}") update(
    @path id: string,
    type?: "preparation" | "finalisation",
    title?: string,
    should_be_planned?: boolean,
    is_required_for_production?: boolean,
    is_external?: boolean,
    is_finished?: boolean,
    dependant_on?: Array<integer>,
  ): SuccessResponse | Error;
  @delete delete(@path id: string): void | SuccessResponse | Error;

  @get @route("/planning-for-week/{week}") getPlanningForWeek(@path week: string): OrderTask | Error;
  // @post @route("{id}/plan") plan(@path id: string, @body ToPlanTasks: ToPlanTaskBody[]): SuccessResponse | Error;
}

//Model: Resource
@route("/resources")
@tag("Resources")
interface Resources {
  @get list(@query query: PaginatedSortableRequest): PaginatedResponse<Resource> | Error;
  @post @route("/") post(@body ResourceBody: ResourceBody): CreatedResponse<Resource> | Error;
  @patch @route("{id}") update(@path id: string, @body ResourceBody: ResourceBody): SuccessResponse | Error;
  @delete delete(@path id: string): void | SuccessResponse | Error;
}

@route("/operating-hours")
@tag("Operating Hours")
interface OperatingHours {
  @get list(): RecordResponse<OperatingHour[]> | Error;
  @post @route("/") post(@body OperatingHour: OperatingHourBody[]): CreatedResponse<OperatingHour[]> | Error;
  @patch @route("{id}") update(@path id: string, @body OperatingHour: OperatingHourBody): SuccessResponse | Error;
  @delete delete(@path id: string): void | SuccessResponse | Error;
}
