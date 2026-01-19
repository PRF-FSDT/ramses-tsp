model PlannedComponentAction {
  @key id: int64;
  order_no: string;
  part_no: string;
  description: string;
  machine_center_no: string;
  requested_by: numeric;
  finished_at: string | null;
}

model PlannedComponentActionStoreBody {
  order_no: PlannedComponentAction.order_no;
  part_no: PlannedComponentAction.part_no;
  description: PlannedComponentAction.description;
  machine_center_no: PlannedComponentAction.machine_center_no;
}

model PlannedComponentActionPatchBody {
  description: PlannedComponentAction.description;
  machine_center_no: PlannedComponentAction.machine_center_no;
}
