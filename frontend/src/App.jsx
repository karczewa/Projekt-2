import { Routes, Route, Navigate } from 'react-router-dom'
import Navbar from './components/Navbar'
import MieszkancyPage from './pages/MieszkancyPage'
import RejestrPage from './pages/RejestrPage'

function App() {
  return (
    <div className="app">
      <Navbar />
      <main className="content">
        <Routes>
          <Route path="/" element={<Navigate to="/mieszkancy" replace />} />
          <Route path="/mieszkancy" element={<MieszkancyPage />} />
          <Route path="/rejestr" element={<RejestrPage />} />
        </Routes>
      </main>
    </div>
  )
}

export default App
