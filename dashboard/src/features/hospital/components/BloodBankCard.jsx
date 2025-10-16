import BloodStockSection from "./BloodStockSection";
import { useNavigate } from "react-router-dom";

export default function BloodBankCard() {
  const navigate = useNavigate();

  return (
    <div className="bg-gradient-to-br from-red-400 to-pink-200 rounded-3xl shadow-lg p-[2px]">
      <div className="bg-white/60 backdrop-blur-md rounded-3xl p-6" onClick={() => navigate("/hospital/blood-bank")} >
          <div className="flex justify-between items-center mb-2">
            <h2 className="text-3xl font-bold">Blood Bank</h2>
            <button
              onClick={() => navigate("/hospital/blood-bank")}
              className="text-red-700 text-3xl"
            >
              →
            </button>
          </div>
          <p className="text-gray-600 mb-6">Current blood stock overview</p>
          <BloodStockSection />
      </div>
    </div>
  );
}
