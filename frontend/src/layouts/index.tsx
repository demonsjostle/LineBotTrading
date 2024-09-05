import React, { ReactNode } from "react";
interface IndexProps {
  children?: ReactNode;
}
import Navbar from "./Navbar";
import Body from "./Body";
const index: React.FC<IndexProps> = ({ children }) => {
  return (
    <React.Fragment>
      <Navbar></Navbar>
      <Body>{children}</Body>
    </React.Fragment>
  );
};

export default index;
