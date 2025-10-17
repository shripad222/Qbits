import BloodStockRow from "./BloodStockRow";
import StatItem from "./StatItem";
import { Activity, Droplet, TrendingUp, AlertTriangle, Calendar } from "lucide-react";

export default function BloodStockSection() {
  const bloodData = [
    { type: "O+", progress: 0.85, units: 42, color: "red-500" },
    { type: "O-", progress: 0.55, units: 22, color: "red-700" },
    { type: "A+", progress: 0.65, units: 28, color: "orange-500" },
    { type: "A-", progress: 0.35, units: 14, color: "orange-700" },
    { type: "B+", progress: 0.45, units: 18, color: "amber-500" },
    { type: "B-", progress: 0.25, units: 10, color: "amber-700" },
    { type: "AB+", progress: 0.2, units: 8, color: "orange-600" },
    { type: "AB-", progress: 0.15, units: 6, color: "orange-800" },
  ];

  const total = bloodData.reduce((sum, b) => sum + b.units, 0);
  const high = bloodData.filter(b => b.progress >= 0.6).map(b => b.type).join(", ");
  const low = bloodData.filter(b => b.progress < 0.3).map(b => b.type).join(", ");

  return (
    <div className="flex gap-6 h-full">
      <div className="flex-[2] overflow-y-auto space-y-4 pr-2">
        {bloodData.map((b) => (
          <BloodStockRow key={b.type} {...b} />
        ))}
      </div>
      
      <div className="flex-1 space-y-4">
        <StatItem icon={Droplet} label="Total Stock" value={`${total} units`} trend={12} />
        <StatItem icon={TrendingUp} label="High Stock" value={high || "None"} />
        <StatItem icon={AlertTriangle} label="Low Stock Alert" value={low || "None"} />
      </div>
    </div>
  );
}
