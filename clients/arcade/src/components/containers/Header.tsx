import logo from "/assets/logo.png";
import { useNavigate } from "react-router-dom";
import { useCallback } from "react";
import { Connection } from "../elements/Connection";

export const Header = () => {
  const navigate = useNavigate();

  const setGameQueryParam = useCallback(
    () => navigate("", { replace: true }),
    [navigate],
  );

  return (
    <div className="w-full flex justify-between items-center px-8 py-2">
      <div className="flex gap-4 items-center">
        <div
          className="flex gap-4 items-center cursor-pointer"
          onClick={setGameQueryParam}
        >
          <img src={logo} alt="Conquest" className="h-12" />
          <p className="text-4xl font-bold">Conquest</p>
        </div>
      </div>
      <div className="flex gap-4 items-center">
        <p className="text-2xl font-bold">{""}</p>
        <Connection />
      </div>
    </div>
  );
};
