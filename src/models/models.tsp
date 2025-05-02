import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

import "./common.tsp";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;


//MODELS:
model Client {
  client_no: string;
  client_name: string;
  client_address_line1: string;
  client_street: string;
  client_street_no: string;
  client_postal_code: string;
  client_city: string;
  client_country_code: string;
}

model Order {
  @key id: int64;
  no?: string | null;
  erp_order_no?: string | null;
  name: string;
  description: string;
  notes: string;
  status: string;
  owner: string;
  responsible: string;
  employee: string;
  ...Client;
  drawing_no: string;
  location: string;

  @visibility("read")
  is_production_planned: boolean;

  prep_start_date: plainDate | null;
  prep_duration_days: integer;
  prod_start_date: plainDate | null;
  prod_duration_days: integer;
  finalisation_start_date: plainDate | null;
  finalisation_duration_days: integer;
  finalisation_date: plainDate | null;
  creation_date: plainDate;

  @visibility("read")
  part_count?: int64;

  @visibility("read")
  article_count?: int64;

  @visibility("read")
  planned_components_count?: int64;
  
  @visibility("read")
  planned_order_positions_count?: int64;

  @visibility("read")
  finished_planned_order_positions_count?: int64;

  created_at: string;
  updated_at: string;
  tasks?: Array<OrderTask> | null;
  planned_order_lines?: Array<PlannedOrderLineWithOrderInfo> | null;
  //@added(Versions.dev) ext_created_at: offsetDateTime;
}

model UpdateOrderBody {
  name?: string;
  no?: string | null;
  description?: string;
  notes?: string;
  status?: string;
  owner?: string;
  responsible?: string;
  employee?: string;
  client_no?: string;
  client_name?: string;
  client_address_line1?: string;
  client_street?: string;
  client_street_no?: string;
  client_postal_code?: string;
  client_city?: string;
  client_country_code?: string;
  drawing_no?: string;
  location?: string;
  prod_duration_days?: integer;
  finalisation_duration_days?: integer;
  prep_duration_days?: integer;

  @encode(DateTimeKnownEncoding.rfc3339)
  finalisation_date?: utcDateTime;
}

model OrderAttachment {
  @key id: uint64;
  order_no: string;
  type: string;
  path: string;
}

model OrderCompositionLine {
  @key id: uint64;
  order_id: uint64;
  order_no: string;
  order_name: string;
  group_name: string | null;
  ext_id: string | null;
  type_no: string | null;
  type_name: string | null;
  part_type_no: string | null;
  part_type_name: string | null;
  plan_pos: string | null;
  ncno: string;
  name: string;
  description?: string | null;
  article_name: string | null;
  subassembly_name: string | null;
  part_name: string | null;
  destination?: string | null;
  length_mm?: numeric | null;
  width_mm?: numeric | null;
  height_mm?: numeric | null;
  cut_length_mm?: numeric | null;
  cut_width_mm?: numeric | null;
  scan_code: string | null;
  is_outsourced: boolean;
}

model SyncedOrderCompositionLine {
  @key id: uint64;
  parent_id?: string | null;
  order_id: uint64;
  order_no: string;
  no: string;
  type?: uint16 | null;
  part_type?: uint16 | null;
  ref?: string | null;
  part_no?: string | null;
  description?: string | null;
  destination?: string | null;
  length_mm?: numeric | null;
  width_mm?: numeric | null;
  height_mm?: numeric | null;
  surf_m2?: numeric | null;
  qty?: uint64 | null;
  material_no: string;
  barcode?: string | null;
  is_outsourced: boolean;
}

model OrderComposition {
  plan_pos: string | null;
  children: OrderCompositionLine[];
}

model AdditionalPurchaseLine {
  @key id: uint64;
  order_no: string;
  material_no: string;
  erp_no?: string | null;
  imos_no?: string | null;
  name: string;
  brand?: string | null;
  type?: string | null;
  category_no?: string | null;
  description?: string | null;
  qty: numeric;
  uom: string;
  length_mm?: numeric | null;
  width_mm?: numeric | null;
  height_mm?: numeric | null;
}

model OrderMaterial {
  @key id: uint64;
  order_no: string;
  material_no: string;
  material_name: string;
  net_qty: float32;
  gross_qty: float32;
  cut_loss: float32;
  uom: string;
  category_no: string | null;
  stock_status: string | null;
}

model OrderMaterialWithItems {
  ...OrderMaterial;
  order_material_items: OrderMaterialItem[];
}

model OrderMaterialItem {
  @key id: uint64;
  order_no: string;
  material_no: string;
  material_name: string;
  item_no: string;
  item_name: string;
  unit_qty: numeric;
  total_qty: numeric;
  qty: numeric;
  uom: string;
  category_no: string | null;
  stock_status: string | null;
  whse_location_code: string | null;
  provision_date: string | null;
  erp_posted_prov_qty : numeric;
  erp_posted_prov_date : string | null;
}

model SyncedOrder {
  @key id: uint64;
  no: string;
  name: string;
  description?: string;
  notes?: string;
  status?: string;
  client_no?: string;
  client_name?: string;
  client_address_line1?: string | null;
  client_street?: string | null;
  client_street_no?: string | null;
  client_postal_code?: string | null;
  client_city?: string | null;
  owner?: string | null;
  responsible?: string | null;
  employee?: string | null;
  drawing_no?: string | null;
  location?: string | null;
  prod_duration_days?: integer | null;
  finalisation_duration_days?: integer | null;
  prep_duration_days?: integer | null;
}

model PlannedOrderLineWithOrderInfo {
  @key id: int64;
  order_no: string | null;
  order_name: string | null;
  order_descr: string | null;
  routing_code: string;
  status: string;
  client_no: string;
  client_name: string;
  planned_mc_no: string;
  planned_start: string;
  planned_duration_in_min: numeric;
  parts_count: numeric;
  finished_parts_count: numeric;
  finished_at: string | null;
}

model PlannedComponentRoutingLine {
  @key id: int64;
  order_no: string;
  no: string;
  part_no: string;
  description: string;
  description_2: string;
  qty: numeric;
  routing_no: string;
  scan_code: string | null;
  status: string;
  can_be_started: boolean;
  is_broken_part: boolean;
  take_from_position_no: string | null;
  finished_at: string | null;
}

model GroupedPlannedComponentRoutingLine {
  plan_pos: string | null;
  component_lines: PlannedComponentRoutingLine[];
}

model PlannedComponent {
  @key id: int32;
  order_no: string;
  part_no: string;
  ncno: string;
  item_no: string | null;
  name: string;
  plan_pos: string | null;
  length_mm: int32 | null;
  width_mm: int32 | null;
  height_mm: int32 | null;
  cut_length_mm: int32 | null;
  cut_width_mm: int32 | null;
  material_no: string | null;
  scan_code: string | null;
  last_scanned_position_type: string | null;
  last_scanned_position_no: string | null;
  move_to_position_type: string | null;
  move_to_position_no: string | null;
  is_waiting_for_sorting_location: boolean;
  is_broken_part: boolean;
  broken_part_reason_id: numeric | null;
  production_started_at: string | null;
  finished_at: string | null;
}

model PlannedComponentDetail {
  ...PlannedComponent;
  plan_pos_id: int16 | null;
  grain_orientation: "unknown" | "longitudinal" | "transversal";
  edge_banding_front: string | null;
  edge_banding_front_trans: string | null;
  edge_banding_back: string | null;
  edge_banding_back_trans: string | null;
  edge_banding_left: string | null;
  edge_banding_left_trans: string | null;
  edge_banding_right: string | null;
  edge_banding_right_trans: string | null;
  edge_banding_top: string | null;
  edge_banding_top_trans: string | null;
  edge_banding_bottom: string | null;
  edge_banding_bottom_trans: string | null;
  prod_planned_start: string | null;
  prod_status: "planned" | "in_production" | "finished";
}

model PlannedOrderPosition {
  @key id: int32;
  order_id: int32;
  order_no: string;
  no: string;
  name: string;
  item_no: string;
  destination: string;
  length_mm: numeric;
  width_mm: numeric;
  height_mm: numeric;
  image: string | null;
  status: "planned" | "in_production" | "finished";
  planned_components: PlannedComponent[];
}

model ResourceBody {
  user_id: integer;
  name: string;
}

model Resource {
  @key id: uint64;
  ...ResourceBody;
}

model OperatingHourBody {
  day: string;
  start: string;
  end: string;
}

model ToPlanTaskBody {
  @key id: uint64;
  duration_in_min: numeric;
  planned_resource_id: numeric;

  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start: utcDateTime;
}

model OperatingHour {
  @key id: int32;
  day: string;
  start: string;
  end: string;
  updated_at: string;
  created_at: string;
}

model StreamedCsvResponse {
  //stream
}



//AUTH
model LoginResponse {
  token: string;
}

model LogoutResponse {
  message: string;
}

model MeResponse {
  name: string;
  email: string;
  role: "user" | "planner" | "admin" | "superadmin";
}

model OrderImportResponse {
  ...Order;
}
model OrderCreateBody {
  synced_order_no?: string | null;
  name: string;

  @encode(DateTimeKnownEncoding.rfc3339)
  finalisation_date: utcDateTime;

  finalisation_duration_days?: integer;
  prod_duration_days?: integer;
  prep_duration_days?: integer;
}

model OrderWorkflowLine {
  routing_code: string;
  machine_type_code: string;
  qty: integer;
  run_time: float;
  setup_time: float;
  machine_center_no: string;
}

model OrderPlanBody {
  @encode(DateTimeKnownEncoding.rfc3339)
  planned_start: utcDateTime;

  routing: {
    routing_code: string;
    run_time: float;
    machine_center_no: string;
  }[];
}

model ScanInfoRequest {
  @query scancode: string;
}

alias PositionType = "machine-center" | "storage-location" | null;

model ScanInfoResponse {
  part_no: string | null;
  nc_no: string | null;
  last_scanned_position_type: PositionType;
  last_scanned_position_no: string | null;
  move_to_position_type: PositionType;
  move_to_position_no: string | null;
  is_waiting_for_sorting_location: boolean;
  requires_sorting: boolean;
  take_from_position_no: string | null;
  error_message: string | null;
}



model OrderIndexFilterRequest {
  ...PaginatedSortableRequest;
  @query status?: string;
  @query owner?: string;
  @query client_name?: string;
  @query finalisation_date_from?: string;
  @query finalisation_date_until?: string;
  @query include?: "tasks";
}

model OrderMaterialIndexFilterRequest {
  ...PaginatedSortableRequest;
  @query category_no?: string;
  @query stock_status?: string;
}

/*model OrderCompositionLineRequest {
  ...PaginatedSortableRequest;
  @query parentId?: int32;
}*/

model OrderMaterialCsvRequest {
  @query excludeRunningMeterParts?: boolean;
  @query excludeSheetMaterials?: boolean;
  @query excludePurchaseParts?: boolean;
  @query excludeFittings?: boolean;
  @query excludeEdging?: boolean;
}

model McPlannedOrdersRequest {
  ...PaginatedRequest;
  @query machine_center_no: string;
}

model McOrderComponentsRequest {
  ...PaginatedRequest;
  @query machine_center_no: string;
  @query routing_code?: string;
  @query order_no: string;
}

model McRegisterOutputRequest {
  @query part_code: string;
  @query machine_center_no: string;
}

model FinishAllBody {
  timestamp: uint16;
  mc: string;
  order_no: string;
}
