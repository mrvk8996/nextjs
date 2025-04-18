export default function NewsList() {
    const news = [
      {
        id: 1,
        title: 'Delhi Metro Update: New Line Launch This Month',
        description: 'The upcoming metro line will reduce travel time across key zones in Delhi.',
      },
      {
        id: 2,
        title: 'Himachal Snowfall: Tourist Influx Increases',
        description: 'Major tourist destinations in Himachal see a rise in visitors after fresh snowfall.',
      },
      {
        id: 3,
        title: 'Goa Beach Safety Guidelines Released',
        description: 'Authorities advise tourists to follow the new safety rules on Goa beaches.',
      },
      {
        id: 4,
        title: 'Rajasthan Desert Safari Season Begins',
        description: 'Explore Jaisalmer with the start of the desert safari season in November.',
      },
      {
        id: 5,
        title: 'Kashmir Tulip Festival Dates Announced',
        description: 'The famous tulip garden in Srinagar will open to tourists from March 25.',
      },
    ];
  
    return (
      <section className="news-list">
        <h2>📰 Latest Travel News</h2>
        <ul>
          {news.map(item => (
            <li key={item.id} className="news-card">
              <h3>{item.title}</h3>
              <p>{item.description}</p>
            </li>
          ))}
        </ul>
      </section>
    );
  }
  