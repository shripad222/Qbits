import React, { useState } from "react";
import { Activity, Droplet, TrendingUp, AlertTriangle, Calendar, Plus, Minus } from "lucide-react";

export default function DetailedBloodBankInfo() {
  const [bloodData, setBloodData] = useState([
    { type: "O+", units: 42, updatedAt: "2025-10-15" },
    { type: "O-", units: 8, updatedAt: "2025-10-14" },
    { type: "A+", units: 28, updatedAt: "2025-10-15" },
    { type: "A-", units: 14, updatedAt: "2025-10-13" },
    { type: "B+", units: 18, updatedAt: "2025-10-15" },
    { type: "B-", units: 6, updatedAt: "2025-10-12" },
    { type: "AB+", units: 12, updatedAt: "2025-10-14" },
    { type: "AB-", units: 5, updatedAt: "2025-10-13" },
  ]);

  const [sortBy, setSortBy] = useState("type");

  const updateUnits = (index, amount) => {
    const newData = [...bloodData];
    const newUnits = Math.max(0, newData[index].units + amount);
    newData[index] = {
      ...newData[index],
      units: newUnits,
      updatedAt: new Date().toISOString().split('T')[0]
    };
    setBloodData(newData);
  };

  if (!bloodData.length) {
    return (
      <div>
        <Droplet className="w-16 h-16 mx-auto mb-4 text-gray-400 opacity-50" />
        <p className="text-lg text-gray-500 dark:text-gray-400">No blood bank data available.</p>
      </div>
    );
  }

  const sortedData = [...bloodData].sort((a, b) => {
    if (sortBy === "units") return b.units - a.units;
    if (sortBy === "date") return new Date(b.updatedAt) - new Date(a.updatedAt);
    return a.type.localeCompare(b.type);
  });

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center shadow-lg">
            <Activity className="w-6 h-6 text-white" />
          </div>
          <div>
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white">
              Blood Bank Inventory
            </h2>
            <p className="text-sm text-gray-600 dark:text-gray-400">Real-time stock levels</p>
          </div>
        </div>
        
        <select 
          value={sortBy}
          onChange={(e) => setSortBy(e.target.value)}
          className="px-4 py-2 rounded-xl bg-white/50 dark:bg-gray-800/50 border border-white/30 dark:border-gray-700/30 backdrop-blur-sm text-sm font-medium text-gray-700 dark:text-gray-300 focus:outline-none focus:ring-2 focus:ring-red-500"
        >
          <option value="type">Sort by Type</option>
          <option value="units">Sort by Units</option>
          <option value="date">Sort by Date</option>
        </select>
      </div>

      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="border-b border-white/20 dark:border-gray-700/50">
              <th className="text-left p-4 text-sm font-semibold text-gray-700 dark:text-gray-300">Blood Type</th>
              <th className="text-left p-4 text-sm font-semibold text-gray-700 dark:text-gray-300">Available Units</th>
              <th className="text-left p-4 text-sm font-semibold text-gray-700 dark:text-gray-300">Actions</th>
              <th className="text-left p-4 text-sm font-semibold text-gray-700 dark:text-gray-300">Last Updated</th>
              <th className="text-left p-4 text-sm font-semibold text-gray-700 dark:text-gray-300">Status</th>
            </tr>
          </thead>
          <tbody>
            {sortedData.map((item, idx) => {
              const originalIdx = bloodData.findIndex(b => b.type === item.type);
              const lowStock = item.units < 10;
              return (
                <tr
                  key={idx}
                  className="group border-b border-white/10 dark:border-gray-700/30 hover:bg-white/20 dark:hover:bg-gray-800/30 transition-all duration-200"
                >
                  <td className="p-4">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 rounded-lg bg-gradient-to-br from-red-500 to-pink-600 flex items-center justify-center shadow-md">
                        <span className="text-white font-bold text-sm">{item.type}</span>
                      </div>
                      <span className="font-semibold text-gray-900 dark:text-white">{item.type}</span>
                    </div>
                  </td>
                  <td className="p-4">
                    <span className="text-2xl font-bold text-gray-900 dark:text-white">{item.units}</span>
                    <span className="text-sm text-gray-600 dark:text-gray-400 ml-1">units</span>
                  </td>
                  <td className="p-4">
                    <div className="flex items-center gap-2">
                      <button
                        onClick={() => updateUnits(originalIdx, -1)}
                        disabled={item.units === 0}
                        className="inline-flex items-center justify-center w-8 h-8 rounded-lg bg-red-500/20 hover:bg-red-500/30 disabled:bg-gray-300/20 disabled:cursor-not-allowed text-red-600 dark:text-red-400 transition-colors"
                        title="Remove unit"
                      >
                        <Minus className="w-4 h-4" />
                      </button>
                      <button
                        onClick={() => updateUnits(originalIdx, 1)}
                        className="inline-flex items-center justify-center w-8 h-8 rounded-lg bg-green-500/20 hover:bg-green-500/30 text-green-600 dark:text-green-400 transition-colors"
                        title="Add unit"
                      >
                        <Plus className="w-4 h-4" />
                      </button>
                    </div>
                  </td>
                  <td className="p-4">
                    <div className="flex items-center gap-2 text-gray-700 dark:text-gray-300">
                      <Calendar className="w-4 h-4" />
                      <span className="text-sm">{new Date(item.updatedAt).toLocaleDateString()}</span>
                    </div>
                  </td>
                  <td className="p-4">
                    <span
                      className={`inline-flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-semibold shadow-sm ${
                        lowStock
                          ? "bg-red-100 text-red-700 dark:bg-red-900/30 dark:text-red-400"
                          : "bg-emerald-100 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400"
                      }`}
                    >
                      {lowStock ? <AlertTriangle className="w-3 h-3" /> : <TrendingUp className="w-3 h-3" />}
                      {lowStock ? "Low Stock" : "Sufficient"}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
