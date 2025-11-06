import "./common.tsp";

model PlannedStep {
  prodOrderTempNo: string;
  orderNo: string;
  itemNo: string;
  quantityPlanned: int32;
  processStepNo: string;
  orderItemProcessStepNo: string;
  sequence: int32;
  durationSeconds: int32;
  shiftId?: int32;
  machineCenterId: int32;
  start: utcDateTime;
  end: utcDateTime;
  stepDueDate: utcDateTime;
  isRoot: boolean;
  existingProdOrderNo: string | null;
  orderTempNo: string | null;
  plannedFromBom: boolean;
}

model SimulationError {
  type: "error" | "warning";
  orderNo: string;
  itemNo: string;
  qty: int32;
  dueDate: utcDateTime;
  message: string;
}

model OverDueItem {
  planned_end: string;
  overdue_days: int32;
  process_step_no: string;
}

model SimulationResult {
  plannedOrderItemsCount: int32;
  plannedSteps: PlannedStep[];
  errors: SimulationError[];
  windowStart: utcDateTime;
  windowEnd: utcDateTime;
  overdueByOrderItemNo: Record<OverDueItem>;
}

model SimulationRunResult {
  simulation_run_id: string; // uuid
  result: SimulationResult;
}

model ApplySimulationBody {
  simulation_run_id: string; // uuid
}
