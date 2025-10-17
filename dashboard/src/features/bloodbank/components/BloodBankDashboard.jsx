import BloodBankCard from "./BloodBankCard";
import AppointmentsCard from "./AppointmentsCard";
import SearchforBlood from "./SearchforBlood";

export default function BloodBankDashboard() {
  return (
    <div className="w-full  p-6 overflow-y-auto space-y-6">
      <BloodBankCard />
      <AppointmentsCard />
      <SearchforBlood/>
    </div>
  );
}
