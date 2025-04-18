import NewsList from "@/components/NewsList";

export default function Home() {
  return (
    <div className="home-page">
      <h2>Hello World from Next.js!</h2>
      <p>This is a basic layout with header and footer.</p>
      <NewsList />
    </div>
  );
}
