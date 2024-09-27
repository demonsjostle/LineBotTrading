import React, { useState } from "react";
import { useUser } from "../../services/queries/useUser";
import { useLogout } from "../../services/queries/useLogout";
import { useNavigate } from "react-router-dom";

const index = () => {
  const [isUserMenuOpen, setIsUserMenuOpen] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);
  const navigate = useNavigate();
  const onLogout = useLogout();

  const { user, isLoading } = useUser();

  const toggleUserMenu = () => {
    setIsUserMenuOpen(!isUserMenuOpen);
  };

  const toggleMobileMenu = () => {
    setIsMobileMenuOpen(!isMobileMenuOpen);
  };

  return (
    <nav className="bg-white border-b border-gray-200 shadow-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16">
          <div className="flex">
            {/* <div className="flex-shrink-0"> */}
            {/*   <a href="/" className="text-xl font-semibold text-gray-900"> */}
            {/*     Brand */}
            {/*   </a> */}
            {/* </div> */}
            <div className="hidden sm:-my-px sm:ml-6 sm:flex sm:space-x-8">
              <a
                href="/"
                className="text-gray-500 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 border-transparent text-sm font-medium"
              >
                Home
              </a>
              {/* <a */}
              {/*   href="/about" */}
              {/*   className="text-gray-500 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 border-transparent text-sm font-medium" */}
              {/* > */}
              {/*   About */}
              {/* </a> */}
              <a
                href="/pricing"
                className="text-gray-500 hover:text-gray-700 inline-flex items-center px-1 pt-1 border-b-2 border-transparent text-sm font-medium"
              >
                Pricing
              </a>
            </div>
          </div>
          {!isLoading && (
            <div className="hidden sm:ml-6 sm:flex sm:items-center">
              <div className="relative">
                {user ? (
                  <>
                    <button
                      type="button"
                      className="flex items-center max-w-xs bg-white rounded-full focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                      onClick={toggleUserMenu}
                    >
                      <img
                        className="h-8 w-8 rounded-full"
                        src={user?.picture}
                        alt="User Profile"
                      />
                    </button>
                    {isUserMenuOpen && (
                      <div
                        className="origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg py-1 bg-white ring-1 ring-black ring-opacity-5"
                        role="menu"
                        aria-orientation="vertical"
                        aria-labelledby="user-menu-button"
                      >
                        <a
                          className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-center cursor-pointer"
                          role="menuitem"
                          onClick={() => navigate("/profile")}
                        >
                          Profile
                        </a>
                        {/* <a */}
                        {/*   className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-center cursor-pointer" */}
                        {/*   role="menuitem" */}
                        {/*   onClick={() => navigate("/settings")} */}
                        {/* > */}
                        {/*   Settings */}
                        {/* </a> */}
                        <a
                          className="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-center cursor-pointer"
                          role="menuitem"
                          onClick={onLogout}
                        >
                          Sign out
                        </a>
                      </div>
                    )}
                  </>
                ) : (
                  <>
                    <button
                      className="bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded"
                      onClick={() => {
                        navigate("/login");
                      }}
                    >
                      Login
                    </button>
                  </>
                )}
              </div>
            </div>
          )}

          <div className="-mr-2 flex items-center sm:hidden">
            <button
              type="button"
              className="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-gray-500 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
              onClick={toggleMobileMenu}
            >
              <span className="sr-only">Open main menu</span>
              <svg
                className="h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth="2"
                  d="M4 6h16M4 12h16M4 18h16"
                />
              </svg>
            </button>
          </div>
        </div>
      </div>

      {isMobileMenuOpen && (
        <div className="sm:hidden" id="mobile-menu">
          <div className="pt-2 pb-3 space-y-1">
            <a
              href="/"
              className="text-gray-500 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 border-indigo-500 text-base font-medium"
            >
              Home
            </a>
            {/* <a */}
            {/*   href="/about" */}
            {/*   className="text-gray-500 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 border-transparent text-base font-medium" */}
            {/* > */}
            {/*   About */}
            {/* </a> */}
            <a
              href="/pricing"
              className="text-gray-500 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 border-transparent text-base font-medium"
            >
              Pricing
            </a>
            {user && (
              <React.Fragment>
                <a
                  href="/profile"
                  className="text-gray-500 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 border-transparent text-base font-medium"
                >
                  Profile
                </a>
                <a
                  onClick={onLogout}
                  className="text-gray-500 hover:text-gray-700 block pl-3 pr-4 py-2 border-l-4 border-transparent text-base font-medium"
                >
                  Sign out
                </a>
              </React.Fragment>
            )}
          </div>
        </div>
      )}
    </nav>
  );
};

export default index;
