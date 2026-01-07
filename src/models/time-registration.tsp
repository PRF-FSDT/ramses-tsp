model TimeRegistration {
  id: numeric;
  order_id: numeric;
  user_id: numeric;
  kind: "production" | "preparation" | "finalisation";
  source: "manual" | "timer";
  is_active: boolean;
  machine_center_no: string | null;
  started_at: utcDateTime;
  ended_at: utcDateTime | null;
  duration_seconds: numeric;
  active_segment: {
    id: numeric;
    started_at: utcDateTime;
    elapsed_seconds: numeric;
  } | null;
  workable: {
    type: string;
    id: numeric;
  };
  created_at: utcDateTime;
  updated_at: utcDateTime;
}
