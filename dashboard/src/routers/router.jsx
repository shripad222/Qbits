import { createBrowserRouter } from "react-router-dom";
import App from "../App.jsx";
import HospitalDashboard from '../features/hospital/components/HospitalDashboard.jsx'
import DetailedBloodBankInfo from "../features/hospital/pages/DetailedBloodBankInfo.jsx";
import NotifyHospital from "../features/hospital/pages/NotifyHospital.jsx";
import BloodBankDashboard from '../features/bloodbank/components/BloodBankDashboard.jsx'
import BloodBankInfo from "../features/bloodbank/pages/BloodBankInfo.jsx";
import HomePage from "../page/HomePage.jsx"
import BloodCampForm from '../features/bloodbank/pages/BloodCampForm.jsx'
import NotifyBloodBank from '../features/bloodbank/pages/NotifyBloodBank.jsx'

const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
    children: [
      {
        path: "/",
        element: <HomePage/>,
      },
      {
        path: "/hospital",
        element: <HospitalDashboard/>,
      },
      {
        path: "/hospital/blood-bank",
        element: <DetailedBloodBankInfo/>,
      },
      {
        path: "/bloodbank",
        element: <BloodBankDashboard />,
      },
      {
        path: "/bloodbank/details",
        element: <BloodBankInfo/>,
      },
      {
        path: "/bloodbank/camps",
        element: <BloodCampForm/>,
      },
      {
        path: "/bloodbank/notify",
        element: <NotifyBloodBank/>,
      },
      {
        path: "/hospital/notify",
        element: <NotifyHospital/>,
      },
    ],
  },
]);

export default router;