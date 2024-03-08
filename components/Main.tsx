'use client'

import React, { useState } from 'react';

export default function Main() {
    const [cardsData, setCardsData] = useState([
        { id: 1, title: "Card 1", description: "This is card 1 description.", quantity: 10 },
        { id: 2, title: "Card 2", description: "This is card 2 description.", quantity: 8 },
        { id: 3, title: "Card 3", description: "This is card 3 description.", quantity: 5 },
    ]);

    const handleBuy = (id) => {
        const newCardsData = cardsData.map(card => {
            if (card.id === id && card.quantity > 0) {
                return { ...card, quantity: card.quantity - 1 };
            }
            return card;
        });
        setCardsData(newCardsData);
    };

    const handleSell = (id) => {
        const newCardsData = cardsData.map(card => {
            if (card.id === id) {
                return { ...card, quantity: card.quantity + 1 };
            }
            return card;
        });
        setCardsData(newCardsData);
    };

    return (
        <div style={{ display: 'flex', flexWrap: 'wrap', gap: '20px', justifyContent: 'center', padding: '20px' }}>
            {cardsData.map((card) => (
                <div key={card.id} style={{ width: '300px', border: '1px solid #ccc', borderRadius: '8px', padding: '20px', boxShadow: '0 2px 5px rgba(0,0,0,0.1)' }}>
                    <h2 style={{ fontSize: '20px', marginBottom: '10px' }}>{card.title}</h2>
                    <p>{card.description}</p>
                    <p>Quantity: {card.quantity}</p>
                    <button onClick={() => handleBuy(card.id)} disabled={card.quantity === 0} style={{ marginRight: '10px' }}>Buy</button>
                    <button onClick={() => handleSell(card.id)}>Sell</button>
                </div>
            ))}
        </div>
    );
}
