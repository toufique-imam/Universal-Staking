import { EthereumClient, w3mConnectors, w3mProvider } from '@web3modal/ethereum'
import { configureChains, createConfig } from 'wagmi'
import { publicProvider } from 'wagmi/providers/public';
import {
    bscTestnet
} from 'wagmi/chains';

export const projectId = 'f4f5c636dfea580a6b5167c97f2f82bc'

export const chains = [ bscTestnet ]
export const { publicClient, webSocketPublicClient } = configureChains( chains,
    [    
        w3mProvider({ projectId }),    
        publicProvider()
    ],
    {
        batch: {
            multicall: true
        }
    }
);

export const wagmiConfig = createConfig({
    autoConnect: true,
    connectors: [...w3mConnectors({ projectId, chains })],
    publicClient,
    webSocketPublicClient
})
export const ethereumClient = new EthereumClient(wagmiConfig, chains)

