import MainLayout from "../../layouts";

const index = () => {
  return (
    <MainLayout>
      <div className="flex items-center justify-center h-screen">
        <div className="text-center">
          <h1 className="text-2xl">Centered Content</h1>
          <p>Home page </p>
        </div>
      </div>
    </MainLayout>
  );
};

export default index;
