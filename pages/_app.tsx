import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import { ToastContainer, toast } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import { WagmiConfig } from 'wagmi';
import { wagmiConfig, ethereumClient, projectId } from '@/utils/wagmi';
import { Web3Modal } from '@web3modal/react'

export default function App({ Component, pageProps }: AppProps) {
  return (
    <WagmiConfig config={wagmiConfig}>
      <ToastContainer position="top-right" autoClose={5000} />
      <Component {...pageProps} />
      <Web3Modal projectId={projectId} ethereumClient={ethereumClient} />
    </WagmiConfig>
  )
}
