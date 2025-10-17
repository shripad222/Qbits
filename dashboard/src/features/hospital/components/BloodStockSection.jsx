import { Activity, Droplet, TrendingUp, AlertTriangle, Calendar, Loader } from "lucide-react";
import { useState } from "react";

const BloodStockRow = ({ type, progress, units, color }) => (
  <div className="flex items-center gap-4 p-3 bg-white/50 dark:bg-gray-800/50 rounded-lg backdrop-blur-sm">
    <div className="w-12 h-12 rounded-lg bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center flex-shrink-0">
      <span className="text-white font-bold text-sm">{type}</span>
    </div>
    <div className="flex-1">
      <div className="flex justify-between mb-1">
        <span className="text-sm font-medium text-gray-900 dark:text-white">{type}</span>
        <span className="text-sm font-semibold text-gray-900 dark:text-white">{units} units</span>
      </div>
      <div className="w-full h-2 bg-gray-200 dark:bg-gray-700 rounded-full overflow-hidden">
        <div
          className={`h-full bg-gradient-to-r from-${color} to-${color} bg-${color}`}
          style={{
            width: `${progress * 100}%`,
            background: `linear-gradient(90deg, rgb(239, 68, 68), rgb(244, 114, 182))`
          }}
        />
      </div>
    </div>
  </div>
);

const StatItem = ({ icon: Icon, label, value, trend }) => (
  <div className="p-4 bg-white/50 dark:bg-gray-800/50 rounded-xl backdrop-blur-sm border border-white/20 dark:border-gray-700/30">
    <div className="flex items-start justify-between mb-2">
      <span className="text-xs font-medium text-gray-600 dark:text-gray-400 uppercase tracking-wide">{label}</span>
      <Icon className="w-5 h-5 text-red-500" />
    </div>
    <p className="text-lg font-bold text-gray-900 dark:text-white break-words">{value}</p>
    {trend && <p className="text-xs text-green-600 dark:text-green-400 mt-1">↑ {trend}% from last week</p>}
  </div>
);

const LoadingAnimation = () => (
  <div className="flex flex-col items-center justify-center h-full gap-4">
    <Loader className="w-12 h-12 text-red-500 animate-spin" />
    <p className="text-sm text-gray-600 dark:text-gray-400">Analyzing inventory patterns...</p>
    <p className="text-xs text-gray-500 dark:text-gray-500">Predicting future blood bank needs</p>
  </div>
);

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

  const [prediction, setPrediction] = useState(null);
  const [loading, setLoading] = useState(false);

  const total = bloodData.reduce((sum, b) => sum + b.units, 0);
  const high = bloodData.filter(b => b.progress >= 0.6).map(b => b.type).join(", ");
  const low = bloodData.filter(b => b.progress < 0.3).map(b => b.type).join(", ");

  const generatePrediction = async () => {
    setLoading(true);
    setPrediction(null);

    const prompt = `You are a blood bank inventory prediction expert. Analyze the following current blood bank stock data and provide a brief, insightful prediction about future inventory needs for the next 7-14 days. Consider seasonal trends, emergency scenarios, and typical blood type demand patterns. Be conversational and provide actionable recommendations.

Current Blood Bank Inventory:
${JSON.stringify(bloodData, null, 2)}

Total Units: ${total}
High Stock Types: ${high || "None"}
Low Stock Types: ${low || "None"}

Provide a 2-3 sentence prediction about what blood types will likely be needed most, what types might face shortages, and one specific action to recommend.`;

    try {
      const response = await fetch('http://10.79.215.218:5000/receive', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ query: prompt })
      });

      const data = await response.json();
      if (data.status === "success") {
        setPrediction(data.response);
      }
    } catch (error) {
      console.error('Error fetching prediction:', error);
      setPrediction("Unable to fetch prediction. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="flex gap-6 h-full">
      <div className="flex-[2] overflow-y-auto space-y-4 pr-2">
        {bloodData.map((b) => (
          <BloodStockRow key={b.type} {...b} />
        ))}
      </div>
      
      <div className="flex-1 flex flex-col gap-4">
        <StatItem icon={Droplet} label="Total Stock" value={`${total} units`} trend={12} />
        <StatItem icon={TrendingUp} label="High Stock" value={high || "None"} />
        <StatItem icon={AlertTriangle} label="Low Stock Alert" value={low || "None"} />
        
        {/* Inventory Prediction Section */}
        <div className="flex-1 p-4 bg-gray-100 dark:bg-gray-700 rounded-xl overflow-hidden flex flex-col">
          {!prediction && !loading && (
            <div className="flex flex-col gap-3 h-full">
              <h3 className="text-sm font-semibold text-gray-900 dark:text-white">Future Needs Prediction</h3>
              <p className="text-xs text-gray-600 dark:text-gray-400 flex-1">
                Get AI-powered predictions for your blood bank inventory needs based on current stock levels and demand patterns.
              </p>
              <button
                onClick={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  generatePrediction();
                }}
                disabled={loading}
                type="button"
                className="px-3 py-2 bg-red-600 hover:bg-red-700 disabled:bg-gray-400 text-white text-sm font-medium rounded-lg transition-colors"
              >
                {loading ? "Generating..." : "Generate Prediction"}
              </button>
            </div>
          )}

          {loading && <LoadingAnimation />}

          {prediction && !loading && (
            <div className="flex flex-col gap-3 h-full">
              <div className="flex items-center justify-between">
                <h3 className="text-sm font-semibold text-gray-900 dark:text-white">Prediction Results</h3>
                <button
                  onClick={generatePrediction}
                  className="text-xs text-red-600 dark:text-red-400 hover:underline"
                >
                  Refresh
                </button>
              </div>
              <div className="flex-1 overflow-y-auto">
                <p className="text-xs text-gray-700 dark:text-gray-300 leading-relaxed whitespace-pre-wrap">
                  {prediction}
                </p>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
