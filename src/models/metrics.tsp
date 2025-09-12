import "@typespec/http";
import "@typespec/rest";
import "@typespec/openapi3";
import "@typespec/versioning";

using TypeSpec.Versioning;
using TypeSpec.Http;
using TypeSpec.Rest;

namespace RamsesService;

model WorkloadForRoutingCode {
  remainingWorkload: numeric;
  startableWorkload: numeric;
  startableParts: numeric;
  todaysFinishedWorkload: numeric;
  todaysFinishedParts: numeric;
}

model Workload {
  routingCode: string;
  metrics: WorkloadForRoutingCode;
}
