import { useEffect, useState } from 'react'
import './App.css'

type Connection = 'connecting' | 'connected' | 'unavailable'

export default function App() {
  const [connection, setConnection] = useState<Connection>('connecting')

  useEffect(() => {
    const controller = new AbortController()
    const timeout = window.setTimeout(() => controller.abort(), 5000)
    fetch('/api/health', { signal: controller.signal })
      .then(async (response) => {
        if (!response.ok) throw new Error('Backend request failed')
        const health: unknown = await response.json()
        if (typeof health !== 'object' || health === null ||
            !('status' in health) || health.status !== 'UP') {
          throw new Error('Unexpected health response')
        }
        setConnection('connected')
      })
      .catch(() => setConnection('unavailable'))
      .finally(() => window.clearTimeout(timeout))
    return () => {
      controller.abort()
      window.clearTimeout(timeout)
    }
  }, [])

  const status = {
    connecting: 'Connecting to the game server…',
    connected: 'Game server connected',
    unavailable: 'Game server unavailable. Start the backend and refresh this page.',
  }[connection]

  return (
    <main>
      <p className="eyebrow">A puzzle for two</p>
      <h1>Multiplayer Picross</h1>
      <p>Solve a picture puzzle together, one square at a time.</p>
      <section aria-labelledby="welcome-heading">
        <h2 id="welcome-heading">Your next puzzle starts here</h2>
        <p>This React frontend is ready for puzzle boards and shared rooms.</p>
        <p className={`connection ${connection}`} role="status">{status}</p>
      </section>
    </main>
  )
}
