import { Inter } from 'next/font/google'
import { Web3Button } from '@web3modal/react'

const inter = Inter({ subsets: ['latin'] })

export default function Home() {
  return (
    <main
      className={`flex min-h-screen flex-col items-center justify-between p-24 ${inter.className}`}>
        <Web3Button />
    </main>
  )
}
