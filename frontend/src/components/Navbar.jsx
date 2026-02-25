import { NavLink } from 'react-router-dom'
import './Navbar.css'

function Navbar() {
  return (
    <nav className="navbar">
      <span className="navbar-logo">Kartoteka Mieszkańca</span>
      <div className="navbar-tabs">
        <NavLink
          to="/mieszkancy"
          className={({ isActive }) => isActive ? 'tab tab--active' : 'tab'}
        >
          Mieszkańcy
        </NavLink>
        <NavLink
          to="/rejestr"
          className={({ isActive }) => isActive ? 'tab tab--active' : 'tab'}
        >
          Rejestr
        </NavLink>
      </div>
    </nav>
  )
}

export default Navbar
