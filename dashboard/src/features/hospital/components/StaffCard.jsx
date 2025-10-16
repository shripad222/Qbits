

export default function StaffCard() {
  return (
    <div className="bg-gradient-to-br from-green-400 to-teal-200 rounded-3xl shadow-lg p-[2px]">
      <div className="bg-white/60 backdrop-blur-md rounded-3xl p-6">
          <h2 className="text-2xl font-bold mb-3">Staff</h2>
          <p className="text-gray-600">
            Manage doctors, nurses, and hospital staff records.
          </p>

          <div className="mt-8 space-y-4">
            <div className="flex justify-between bg-white/70 rounded-xl p-3 shadow-sm">
              <span className="font-semibold text-gray-700">Dr. Arjun Mehta</span>
              <span className="text-green-600 font-medium">On Duty</span>
            </div>

            <div className="flex justify-between bg-white/70 rounded-xl p-3 shadow-sm">
              <span className="font-semibold text-gray-700">Nurse Priya</span>
              <span className="text-yellow-600 font-medium">Break</span>
            </div>

            <div className="flex justify-between bg-white/70 rounded-xl p-3 shadow-sm">
              <span className="font-semibold text-gray-700">Lab Tech Rohit</span>
              <span className="text-red-600 font-medium">Off Duty</span>
            </div>
          </div>
      </div>
    </div>
  );
}
