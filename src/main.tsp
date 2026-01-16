import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";
import "./models/common.tsp";
import "./models/models.tsp";
import "./models/users.tsp";
import "./models/machine-centers.tsp";
import "./models/machine-types.tsp";
import "./models/routing-codes.tsp";
import "./models/order-lines.tsp";
import "./models/broken-parts.tsp";
import "./models/additional-purchase-parts.tsp";
import "./models/storage-locations.tsp";
import "./models/scan.tsp";
import "./models/items.tsp";
import "./models/app-settings.tsp";
import "./models/order-tasks.tsp";
import "./models/metrics.tsp";
import "./models/time-registration-codes.tsp";
import "./models/planned-machine-center-shift.tsp";
import "./models/machine-center-shift.tsp";
import "./models/simulation.tsp";
import "./models/site.tsp";
import "./models/time-registration.tsp";
import "./models/resource-shift.tsp";
import "./models/planned-resource-shift.tsp";

import "./responses/responses.tsp";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

@versioned(Versions)
@service({
  title: "RAMSES",
})
namespace RamsesService;

//AUTH
@tag("Auth")
interface Auth {
  @route("login") @post postLogin(email: string, password: string, device_name: string): LoginResponse | ValidationError;
  @route("logout") @post postLogout(): LogoutResponse;
  @route("me") @get getMe(): MeResponse;
  @route("me") @post updateMe(name?: string, email?: string, password?: string, password_confirmation?: string): SuccessResponse;
}

//DEMO
@tag("Demo")
interface Demo {
  @route("/reset-demo") @post resetDemo(): SuccessResponse;
}
@tag("Sites")
@route("/sites")
interface Sites {
  @get list(...PaginatedRequest): PaginatedResponse<Site>;
  @get @route("{id}") read(@path id: string): ReadResponse<Site>;
  @post @route("") post(@body SiteBody: SiteBody): CreatedResponse<Site>;
  @patch @route("{id}") update(@path id: string, @body SiteBody: SiteBody): UpdatedResponse<Site>;
  @delete delete(@path id: string): DeletedResponse;
}

//ORDER MANAGER
//Model: Additional Purchase Parts
@route("/order-manager/additional-purchase-parts")
@tag("Additional Purchase Parts")
interface AdditionalPurchaseParts {
  @get list(...PaginatedRequest): PaginatedResponse<AdditionalPurchasePart>;
}

//Model: Orders
@route("/order-manager/orders")
@tag("Orders")
interface Orders {
  @get list(...OrderIndexFilterRequest): PaginatedResponse<Order>;
  @get @route("{id}") read(@path id: string): ReadResponse<Order>;
  @patch @route("{id}") update(@path id: string, ...UpdateOrderBody): UpdatedResponse<Order>;
  @post @route("/") post(@body OrderCreateBody: OrderCreateBody): CreatedResponse<Order>;
  @delete delete(@path id: string): DeletedResponse;

  @route("{id}/export-order-csvs") @get getOrderCsvs(@path id: string, ...OrderCsvRequest): StreamedZipResponse | Error;

  //attachments
  @route("{id}/attachments") @get getAttachments(@path id: string, ...PaginatedRequest): PaginatedResponse<OrderAttachment>;
  @route("{id}/attachments") @post postAttachments(@path id: string): ActionResponse;
  @route("{id}/attachment-upload") @post uploadOrderAttachment(
    @path id: string,
    @header contentType: "multipart/form-data",
    @multipartBody body: {
      file: HttpPart<File>;
      delimiter?: HttpPart<string>;
    },
  ): ActionResponse;

  //composition lines
  @route("{id}/composition") @get getCompositionLines(@path id: string, ...PaginatedSortableRequest): PaginatedResponse<OrderComposition>;

  //order tasks
  @route("{id}/order-tasks") @get getOrderTasks(@path id: string, ...OrderTaskFilterRequest): PaginatedResponse<OrderTask>;

  //additional purch lines
  @route("{id}/additional-purchase-lines") @get getAdditionalPurchLines(
    @path id: string,
    ...PaginatedSortableRequest,
  ): PaginatedResponse<AdditionalPurchaseLine>;
  @route("{id}/additional-purchase-lines") @post postAdditionalPurchLines(
    @path id: string,
    erp_no?: string,
    material_no?: string,
    name?: string,
    brand?: string,
    type?: string,
    qty?: numeric,
    uom?: string,
    length_mm?: integer,
    width_mm?: integer,
    height_mm?: integer,
  ): CreatedResponse<AdditionalPurchaseLine>;
  @route("{id}/additional-purchase-lines-csv")
  @get
  getAdditionalPurchaseLineCsv(@path id: string): StreamedCsvResponse | Error;

  //order materials
  @route("{id}/order-materials") @get getOrderMaterials(@path id: string, ...OrderMaterialIndexFilterRequest): PaginatedResponse<OrderMaterialWithItems>;
  @route("{id}/order-materials-csv") @get getOrderMaterialsCsv(@path id: string, ...OrderMaterialCsvRequest): StreamedCsvResponse | Error;

  //actions
  @route("{id}/push-order-to-erp") @post postOrderToErp(@path id: string): string | Error;
  @route("{id}/push-materials-to-erp") @post postMaterialsToErp(@path id: string): string | Error;
}

@route("/order-manager")
@tag("Order Material Categories")
interface OrderMaterialCategory {
  @get @route("/order-material-categories") getOrderMaterialCategories(): ListResponse<numeric>;
}

//Model: SyncedOrder
@route("/order-manager/importable-orders")
@tag("Importable Orders")
interface ImportableOrders {
  @get list(...PaginatedRequest): PaginatedResponse<SyncedOrder>;
  //@route("{/") @get analyze(@path id: string): string | Error;
}

@route("/order-manager/imported-orders")
@tag("Imported Orders")
interface ImportedOrders {
  @delete delete(@path id: string): DeletedResponse;
}

//Model: OrderAttachment
@route("/order-manager/attachments")
@tag("Attachments")
interface OrderAttachments {
  @get read(@path id: string): OrderAttachment | Error; //TODO: also return file contents
  @delete delete(@path id: string): DeletedResponse;
}

//Model: OrderCompositionLine
@route("/order-manager/composition-lines")
@tag("Composition Lines")
interface OrderCompositionLines {
  @patch @route("/outsource-multiple") outsourceMultiple(is_outsourced: boolean, line_ids: int32[]): UpdatedResponse<OrderCompositionLine[]>;
  @patch @route("{id}") update(@path id: string, is_outsourced: boolean): UpdatedResponse<OrderCompositionLine>;
  @patch @route("{orderId}/is-outsourced") patchIsOutsourcedForOrder(@path orderId: string, is_outsourced: boolean): UpdatedResponse<OrderCompositionLine[]>;
  @route("{orderId}/order-composition-lines-csv")
  @get
  getOrderCompositionLineCsv(@path orderId: string, ...OrderCompositionCsvRequest): StreamedCsvResponse | Error;
  @route("{orderId}/outsourced-composition-lines-csv")
  @get
  getOutsourcedCompositionLineCsv(@path orderId: string, ...OrderCompositionCsvRequest): StreamedCsvResponse | Error;
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
  ): UpdatedResponse<AdditionalPurchaseLine>;
  @delete delete(@path id: string): DeletedResponse;
}

//Model: OrderMaterialItem
@route("/order-manager/order-material-items")
@tag("Order Material Items")
interface OrderMaterialItems {
  @patch @route("{id}") update(@path id: string, qty: numeric): UpdatedResponse<OrderMaterialItem>;
}

//Model: OrderTask
@route("/order-manager/order-tasks")
@tag("Order Tasks")
interface OrderTasks {
  @post @route("/") post(@body OrderTaskBody: OrderTaskBody): CreatedResponse<OrderTask>;
  @patch @route("{id}") update(@path id: string, @body OrderTaskUpdateBody: OrderTaskUpdateBody): UpdatedResponse<OrderTask>;
  @delete delete(@path id: string): DeletedResponse;
  @post @route("/{id}/finish") finishTask(@path id: string): RecordResponse<OrderTask> | NotFoundError;
  @post @route("/{id}/timer/start") startTimer(@path id: string): CreatedResponse<TimeRegistration> | NotFoundError;
  @post @route("/{id}/timer/stop") stopTimer(@path id: string): UpdatedResponse<TimeRegistration> | NotFoundError;
  @get @route("/planning") getPlanning(@query start: string, @query end: string): ListResponse<OrderTask>;
  @get @route("/planning-for-week/{week}") getPlanningForWeek(@path week: string): PaginatedResponse<OrderTask>;
  @get @route("/planned-tasks") getPlannedTasks(...PlannedTasksRequest): PaginatedResponse<OrderTask>;
  // @post @route("{id}/plan") plan(@path id: string, @body ToPlanTasks: ToPlanTaskBody[]): SuccessResponse | Error;
}

//Model: OrderTask
@route("/order-manager/order-task-templates")
@tag("Order Task Templates")
interface OrderTaskTemplates {
  @get list(...PaginatedSortableRequest): PaginatedResponse<OrderTaskTemplate>;
  @post @route("/") post(@body OrderTaskTemplateBody: OrderTaskTemplateBody): CreatedResponse<OrderTaskTemplate>;
  @patch @route("{id}") update(@path id: string, @body OrderTaskTemplateBody: OrderTaskTemplateBody): UpdatedResponse<OrderTaskTemplate>;
  @delete delete(@path id: string): DeletedResponse;
}

//Model: TimeRegistrationCode
@route("/order-manager/time-registration-codes")
@tag("Time Registration Codes")
interface TimeRegistrationCodes {
  @get list(...PaginatedSortableRequest): PaginatedResponse<TimeRegistrationCode>;
  @post @route("/") post(@body TimeRegistrationCodeBody: TimeRegistrationCodeBody): CreatedResponse<TimeRegistrationCode>;
  @patch @route("{id}") update(@path id: string, @body TimeRegistrationCodeBody: TimeRegistrationCodeBody): UpdatedResponse<TimeRegistrationCode>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/order-manager")
@tag("Order Manager")
interface OrderManager {
  @route("/sync-erp-data") @post syncErpData(): SuccessResponse | Error;
  @route("/csv-import/composition") @post importCompositionCsv(
    @header contentType: "multipart/form-data",
    @multipartBody body: {
      file: HttpPart<File>;
      delimiter?: HttpPart<string>;
    },
  ): SuccessResponse | Error;
}

//Model: Item
@route("/materials-manager/items")
@tag("Items")
interface Items {
  @get list(...ItemIndexFilterRequest): PaginatedResponse<Item>;
  @post @route("/") post(@body ItemBody: ItemBody): CreatedResponse<Item>;
  @patch @route("{id}") update(@path id: string, @body ItemBody: ItemBody): UpdatedResponse<Item>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/materials-manager")
@tag("Materials Manager")
interface ItemsExport {
  @get @route("/items-csv") itemsCsv(): string;
}

//Model: Resource
@route("/resources")
@tag("Resources")
interface Resources {
  @get list(...PaginatedSortableRequest): PaginatedResponse<Resource>;
  @post @route("/") post(@body ResourceBody: ResourceBody): CreatedResponse<Resource>;
  @patch @route("{id}") update(@path id: string, @body ResourceBody: ResourceBody): UpdatedResponse<Resource>;
  @delete delete(@path id: string): DeletedResponse;
}
@route("/resource-shifts")
@tag("Resource Shifts")
interface ResourceShifts {
  @get list(...PaginatedRequest): PaginatedResponse<ResourceShift>;
  @get @route("{id}") read(@path id: string): ReadResponse<ResourceShift>;
  @post @route("") post(@body ResourceShiftBody: ResourceShiftBody): CreatedResponse<ResourceShift>;
  @patch @route("{id}") update(@path id: string, @body ResourceShiftBody: ResourceShiftBody): UpdatedResponse<ResourceShift>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/planned-resource-shifts")
@tag("Planned Resource Shifts")
interface PlannedResourceShifts {
  @get list(
    @query resource_id?: numeric,
    @query simulation_run_id?: string | null,
    @query start?: int64,
    @query end?: int64,
    @query per_page?: int32,
  ): PlannedResourceShiftResponse;
  @post @route("/") generateShifts(
    @body body: {
      // start & end are unix timestamps (seconds since epoch)
      start: int64;

      end?: int64;
    },
  ): CreatedResponse<{
    message: string;
  }> | BadRequestError;
  @get @route("/{id}") read(@query simulation_run_id?: string | null, @path id: numeric): ReadResponse<PlannedResourceShift>;
  @patch @route("/{id}") update(
    @path id: numeric,
    @body body: {
      is_disabled?: boolean;
      is_locked?: boolean;
      shift_name?: string;
    },
  ): UpdatedResponse<PlannedResourceShift>;
  @delete @route("/{id}") delete(@path id: numeric): DeletedResponse;
}

@route("/operating-hours")
@tag("Operating Hours")
interface OperatingHours {
  @get list(): RecordResponse<OperatingHour[]>;
  @post @route("/") post(@body OperatingHour: OperatingHourBody[]): CreatedResponse<OperatingHour[]>;
  @patch @route("{id}") update(@path id: string, @body OperatingHour: OperatingHourBody): UpdatedResponse<OperatingHour>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/users")
@tag("Users")
interface Users {
  @get list(...PaginatedRequest): PaginatedResponse<User>;
  @get @route("{id}") read(@path id: string): ReadResponse<User>;
  @post @route("") post(@body UserBody: UserCreateBody): CreatedResponse<User>;
  @patch @route("{id}") update(@path id: string, @body UserBody: UserUpdateBody): UpdatedResponse<User>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/production-planning")
@tag("Production Planning")
interface ProductionPlanningOrders {
  @get @route("/orders/unplanned") getUnplanned(...PaginatedRequest): PaginatedResponse<Order>;
  @get @route("/orders/planned") getPlanned(...PaginatedRequest): PaginatedResponse<PlannedOrder>;
  @get @route("/orders/{id}/workflow") workflow(@path id: string): ListResponse<OrderWorkflowLine>;
  @post @route("/orders/{id}/plan") plan(@path id: string, @body orderPlanBody: OrderPlanBody): SuccessResponse;
  @post @route("/orders/{id}/autoplan") autoplan(@path id: string): SuccessResponse;
  @post @route("/orders/{id}/unplan") unplan(@path id: string): SuccessResponse;
  @post @route("/order-tasks/{id}/unplan") unplanOrderTask(@path id: string): SuccessResponse;
  @post @route("/orders/{id}/order-tasks/plan") planOrderTasks(@path id: string, @body ToPlanTasks: ToPlanTaskBody[]): CreatedResponse<ToPlanTaskBody[]>;
  @get @route("/planned-orders-for-week/{week}") plannedOrderLines(@path week: string): ListResponse<PlannedOrderLine>;
  @patch @route("/planned-order-line/{id}") updatePlannedOrderLine(@path id: string, @body body: PlannedOrderLineBody): UpdatedResponse<PlannedOrderLine>;
  @post @route("/run-simulation") runSimulation(): CreatedResponse<SimulationRunResult> | Error;
  @post @route("/apply-simulation") applySimulation(@body body: ApplySimulationBody): SuccessResponse | Error;
  @post @route("/decline-simulation") declineSimulation(@body body: ApplySimulationBody): SuccessResponse | Error;
}

@route("/storage-locations")
@tag("Storage Locations")
interface StorageLocations {
  @get list(@query mc?: string, ...PaginatedSortableRequest): PaginatedResponse<StorageLocation>;
  @get @route("{id}") read(@path id: string): ReadResponse<StorageLocation>;
  @post @route("") post(@body StorageLocationBody: StorageLocationBody): CreatedResponse<StorageLocation>;
  @patch @route("{id}") update(@path id: string, @body StorageLocationBody: StorageLocationBody): UpdatedResponse<StorageLocation>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/mes/machine-centers")
@tag("Machine Centers")
interface MachineCenters {
  @get list(...PaginatedSortableRequest): PaginatedResponse<MachineCenterWithScanners>;
  @get @route("{id}") read(@path id: string): ReadResponse<MachineCenterWithScanners>;
  @post @route("") post(@body MachineBody: MachineCenterBody): CreatedResponse<MachineCenter>;
  @patch @route("{id}") update(@path id: string, @body MachineBody: MachineCenterPatchBody): UpdatedResponse<MachineCenter>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/mes/machine-center-shifts")
@tag("Machine Center Shifts")
interface MachineCenterShifts {
  @get list(...PaginatedRequest): PaginatedResponse<MachineCenterShift>;
  @post @route("/") post(@body MachineCenterShiftBody: MachineCenterShiftBody): CreatedResponse<MachineCenterShift>;
  @patch @route("{id}") update(@path id: string, @body MachineCenterShiftBody: MachineCenterShiftBody): UpdatedResponse<MachineCenterShift>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/mes/planned-machine-center-shifts")
@tag("Planned Machine Center Shifts")
interface PlannedMachineCenterShifts {
  @get list(
    @query machine_center_id?: int64,
    @query simulation_run_id?: string | null,
    @query start?: int64,
    @query end?: int64,
    @query per_page?: int32,
  ): PlannedMachineCenterShiftResponse;

  @post @route("/") generateShifts(
    @body body: {
      // start & end are unix timestamps (seconds since epoch)
      start: int64;

      end?: int64;
    },
  ): CreatedResponse<{
    message: string;
  }> | BadRequestError;

  @get @route("/{id}") read(@query simulation_run_id?: string | null, @path id: int64): ReadResponse<PlannedMachineCenterShift>;

  @patch @route("/{id}") update(
    @path id: int64,
    @body body: {
      is_disabled?: boolean;
      is_locked?: boolean;
      shift_name?: string;
    },
  ): UpdatedResponse<PlannedMachineCenterShift>;

  @delete @route("/{id}") delete(@path id: int64): DeletedResponse;
}

@route("/mes/machine-types")
@tag("Machine Types")
interface MachineTypes {
  @get list(...PaginatedRequest): PaginatedResponse<MachineType>;
  @post @route("/") post(@body MachineBody: MachineTypeBody): CreatedResponse<MachineType>;
  @patch @route("{id}") update(@path id: string, @body MachineBody: MachineTypeBody): UpdatedResponse<MachineType>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/mes/routing-codes")
@tag("Routing Codes")
interface RoutingCodes {
  @get list(...PaginatedRequest): PaginatedResponse<RoutingCode>;
  @get @route("{id}") read(@path id: string): ReadResponse<RoutingCode>;
  @post @route("") post(@body RoutingCodeBody: RoutingCodeBody): CreatedResponse<RoutingCode>;
  @patch @route("{id}") update(@path id: string, @body RoutingCodeBody: RoutingCodeBody): UpdatedResponse<RoutingCode>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/mes/prod-overview")
@tag("Prod Overview")
interface MesProdOverview {
  //DEPRECATED -> moved to PROD ORDERS
  @get list(...OrderIndexFilterRequest): PaginatedResponse<Order>;
}

@route("/mes/metrics")
@tag("Prod Metrics")
interface MesProdMetrics {
  @get @route("/workload") workload(): ListResponse<Workload>;
}

@route("/mes/orders")
@tag("Prod Orders")
interface MesOrders {
  @get list(...OrderIndexFilterRequest): PaginatedResponse<Order>;
  //@get @route("/{id}") detail(@path id: string, ...OrderIndexFilterRequest): PaginatedResponse<Order>;
  @get @route("/{id}/planned-order-lines") getOrderPlannedOrderLines(@path id: string, ...PaginatedSortableRequest): PaginatedResponse<PlannedOrderLine>;
  @get @route("/{id}/plan-positions") getOrderPlanPositions(@path id: string, ...PaginatedSortableRequest): PaginatedResponse<PlannedOrderPosition>;
  @get @route("/{id}/plan-positions/{planPosNo}") getOrderPlanPosDetail(@path id: string, @path planPosNo: string): PlannedOrderPosition;
  @get @route("/{id}/articles/{partNo}") getOrderArticleDetail(@path id: string, @path partNo: string): PlannedComponentDetail;
  @get @route("/{id}/articles/{partNo}/routing") getOrderArticleRouting(
    @path id: string,
    @path partNo: string,
    ...PaginatedSortableRequest,
  ): PaginatedResponse<PlannedComponentRoutingLine>;
  @get @route("/{id}/saw-materials") getOrderSawMaterials(@path id: string, ...PaginatedSortableRequest): PaginatedResponse<OrderMaterialItem>;
  @get @route("/{id}/edge-banding") getOrderEdgeBanding(@path id: string, ...PaginatedSortableRequest): PaginatedResponse<OrderMaterial>;
}

@route("/mes/machine-center")
@tag("Machine Center")
interface MesMachineCenter {
  @get @route("/orders") getOrders(...McPlannedOrdersRequest): PaginatedResponse<PlannedOrderLine>;
  @get @route("/order-components") getOrderComponents(...McOrderComponentsRequest): PaginatedResponse<PlannedComponentRoutingLine>;
  @get @route("/grouped-order-components") getGroupedOrderComponents(...McOrderComponentsRequest): PaginatedResponse<GroupedPlannedComponentRoutingLine>;
  @get @route("/scan-info") getScanInfo(...ScanInfoRequest): ScanInfoResponse | NotFoundError;

  @post @route("/{plannedOrderLineId}/start") startProductionTimer(
    @path plannedOrderLineId: string,
    @body start: {
      machine_center_no: string;
      timestamp: unixTimestamp32;
    },
  ): CreatedResponse<TimeRegistration> | NotFoundError;
  @post @route("/{plannedOrderLineId}/stop") stopProductionTimer(
    @path plannedOrderLineId: string,
    @body stop: {
      timestamp: unixTimestamp32;
    },
  ): UpdatedResponse<TimeRegistration> | NotFoundError;
  @post @route("/{plannedOrderLineId}/pause") pauseProductionTimer(
    @path plannedOrderLineId: string,
    @body pause: {
      timestamp: unixTimestamp32;
    },
  ): UpdatedResponse<TimeRegistration> | NotFoundError;

  @post @route("/register-output") registerOutput(...McRegisterOutputRequest): SuccessResponse;
  @post @route("/finish-all") finishAll(@body finishAllBody: FinishAllBody): SuccessResponse | NotFoundError;
}

@route("/mes/broken-part-reasons")
@tag("Broken Part Reasons")
interface BrokenPartReasons {
  @get list(...PaginatedSortableRequest): PaginatedResponse<BrokenPartReason>;
  @post @route("/") post(@body BrokenPartReasonBody: BrokenPartReasonBody): CreatedResponse<BrokenPartReason>;
  @patch @route("{id}") update(@path id: string, @body BrokenPartReasonBody: BrokenPartReasonBody): UpdatedResponse<BrokenPartReason>;
  @delete delete(@path id: string): DeletedResponse;
}

@route("/mes/broken-parts")
@tag("Broken Parts")
interface BrokenParts {
  @get list(...PaginatedSortableRequest): PaginatedResponse<BrokenPlannedComponent>;
  @post @route("/register") register(@body BrokenPartRegisterBody: BrokenPartRegisterBody): SuccessResponse | NotFoundError;
  @post @route("{id}/repair") repair(@path id: string): SuccessResponse | NotFoundError;
}

@route("/mes/scan")
@tag("Scan")
interface ScanEndpoint {
  @post scan(@body ScanBody: ScanBody): CreatedResponse<Scan>;
}

@route("/media")
@tag("Media")
interface Media {
  @get @route("/image") getImage(@query orderNo: string, @query barcode: string): string | Error;
}

@route("/upload")
@tag("Upload")
interface Upload {
  @post @route("/chunk") postChunk(sessionId: string, fileName: string, chunkNumber: integer, data: string): SuccessResponse | Error;
  @post @route("/process") processChunkedUpload(sessionId: string, fileName: string, action: string): SuccessResponse | Error;
}

@route("/app-settings")
@tag("AppSettings")
interface AppSettings {
  @get list(): AppSetting;
  @patch update(@body AppSettingBody: AppSettingBody): SuccessResponse | NotFoundError;
}
