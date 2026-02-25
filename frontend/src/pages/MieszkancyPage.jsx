function MieszkancyPage() {
  return (
    <div className="page">
      <div className="page-header">
        <h1>Mieszkańcy</h1>
        <button className="btn btn--primary">+ Zarejestruj mieszkańca</button>
      </div>
      <div className="search-bar">
        <input
          type="text"
          placeholder="Szukaj po nazwisku, PESEL lub adresie..."
          className="search-input"
        />
      </div>
      <div className="empty-state">
        <p>Wpisz frazę wyszukiwania, aby znaleźć mieszkańców.</p>
      </div>
    </div>
  )
}

export default MieszkancyPage
