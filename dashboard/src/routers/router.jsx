import { createBrowserRouter } from "react-router-dom";
import App from "../App.jsx";
import HospitalDashboard from '../features/hospital/components/HospitalDashboard.jsx'
import DetailedBloodBankInfo from "../features/hospital/pages/DetailedBloodBankInfo.jsx";
// import Home from "../pages/home/Home";
// import Login from "../components/Login.jsx";
// import Register from "../components/Register.jsx";
// import CartPage from "../pages/scrapitem/CartPage.jsx";
// import CheckoutPage from "../pages/scrapitem/CheckoutPage.jsx";
// import SingleScrapMaterial from "../pages/scrapitem/SingleScrapMaterial.jsx";
// import OrderPage from "../pages/scrapitem/OrderPage.jsx";
// import Shop from "../pages/shop/Shop.jsx";
// import AddItem from "../pages/AddItem/AddItem.jsx";
// import PrivateRoute from "./PrivateRoute";
const router = createBrowserRouter([
  {
    path: "/",
    element: <App />,
    children: [
      {
        path: "/",
        element: <HospitalDashboard/>,
      },
      {
        path: "/hospital/blood-bank",
        element: <DetailedBloodBankInfo/>,
      },
    //   {
    //     path: "/login",
    //     element: <Login />,
    //   },
    //   {
    //     path: "/cart",
    //     element: <PrivateRoute><CartPage /></PrivateRoute>,
    //   },
    //   {
    //     path: "/checkout",
    //     element: <PrivateRoute><CheckoutPage/></PrivateRoute>,
    //   },
    //   {
    //     path: "/scrap/:id",
    //     element: <SingleScrapMaterial />,
    //   },
    //   {
    //     path: "/shop",
    //     element:<PrivateRoute><Shop/></PrivateRoute>,
    //   },
    //   {
    //     path: "/register",
    //     element: <Register/>,
    //   },
    //   {
    //     path: "/create",
    //     element: <AddItem/>,
    //   },
    ],
  },
]);

export default router;