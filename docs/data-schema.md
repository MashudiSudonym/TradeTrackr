# TradeTrackr - Data Schema Specification

Dokumen ini menjelaskan struktur data yang diharapkan untuk jurnal trading di aplikasi TradeTrackr. Struktur ini akan menjadi dasar pembuatan entity, model, dan database schema.

---

## Trade Entry Data Schema

### Field Definitions

| Field Name       | Data Type | Required | Description                                    | Sample Value              |
|------------------|-----------|----------|------------------------------------------------|---------------------------|
| id               | String    | Yes      | Unique identifier untuk setiap trade entry     | "uuid-1234-5678"          |
| dateTimeEntry    | DateTime  | Yes      | Tanggal dan waktu masuk posisi trading         | 2025-10-27 13:45:00       |
| dateTimeExit     | DateTime  | Yes      | Tanggal dan waktu keluar dari posisi trading   | 2025-10-27 15:00:00       |
| instrument       | String    | Yes      | Nama instrumen atau aset yang diperdagangkan   | "BTC/USDT"                |
| transactionType  | String    | Yes      | Jenis transaksi (Buy/Sell atau Long/Short)     | "Buy"                     |
| positionSize     | Double    | Yes      | Ukuran posisi dalam lot atau kontrak           | 0.5                       |
| entryPrice       | Double    | Yes      | Harga saat masuk posisi                        | 54000.00                  |
| exitPrice        | Double    | Yes      | Harga saat keluar dari posisi                  | 54500.00                  |
| stopLoss         | Double    | Yes      | Level stop loss yang ditetapkan                | 53500.00                  |
| takeProfit       | Double    | Yes      | Level take profit yang ditetapkan              | 55000.00                  |
| entryReason      | String    | Yes      | Alasan atau strategi masuk trade               | "Breakout from resistance" |
| additionalNotes  | String    | No       | Catatan tambahan (psikologi, emosi, kondisi)   | "Market looks bullish"    |
| profitLoss       | Double    | Yes      | Nilai keuntungan atau kerugian (nominal)       | 500.00                    |
| profitLossPct    | Double    | Yes      | Persentase keuntungan atau kerugian            | 0.92                      |
| createdAt        | DateTime  | Yes      | Timestamp saat data dibuat di database         | 2025-10-27 15:05:00       |
| updatedAt        | DateTime  | No       | Timestamp saat data terakhir diupdate          | 2025-10-27 15:10:00       |

---

## Transaction Type Enum

Untuk memastikan konsistensi data, field `transactionType` menggunakan nilai enum:

- **Buy** - Membuka posisi long atau membeli aset
- **Sell** - Membuka posisi short atau menjual aset

---

## Sample Data Entry

Berikut adalah contoh lengkap satu entry data jurnal trading:

```json
{
  "id": "a1b2c3d4-e5f6-7890-abcd-1234567890ab",
  "dateTimeEntry": "2025-10-27T13:45:00Z",
  "dateTimeExit": "2025-10-27T15:00:00Z",
  "instrument": "BTC/USDT",
  "transactionType": "Buy",
  "positionSize": 0.5,
  "entryPrice": 54000.00,
  "exitPrice": 54500.00,
  "stopLoss": 53500.00,
  "takeProfit": 55000.00,
  "entryReason": "Breakout from resistance level at 53800",
  "additionalNotes": "Market looks bullish. Good momentum and volume.",
  "profitLoss": 500.00,
  "profitLossPct": 0.92,
  "createdAt": "2025-10-27T15:05:00Z",
  "updatedAt": "2025-10-27T15:10:00Z"
}
```

---

## Database Table Schema (SQL Equivalent)

Untuk referensi, berikut adalah representasi schema dalam SQL (akan digunakan dalam Drift):

```sql
CREATE TABLE trades (
  id TEXT PRIMARY KEY NOT NULL,
  date_time_entry INTEGER NOT NULL,
  date_time_exit INTEGER NOT NULL,
  instrument TEXT NOT NULL,
  transaction_type TEXT NOT NULL,
  position_size REAL NOT NULL,
  entry_price REAL NOT NULL,
  exit_price REAL NOT NULL,
  stop_loss REAL NOT NULL,
  take_profit REAL NOT NULL,
  entry_reason TEXT NOT NULL,
  additional_notes TEXT,
  profit_loss REAL NOT NULL,
  profit_loss_pct REAL NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER
);
```

---

## Validations

Berikut adalah aturan validasi untuk setiap field:

- **id**: Harus unique, generated menggunakan UUID
- **dateTimeEntry**: Tidak boleh di masa depan
- **dateTimeExit**: Harus lebih besar dari dateTimeEntry
- **instrument**: Minimal 3 karakter, tidak boleh kosong
- **transactionType**: Hanya menerima nilai "Buy" atau "Sell"
- **positionSize**: Harus lebih besar dari 0
- **entryPrice**: Harus lebih besar dari 0
- **exitPrice**: Harus lebih besar dari 0
- **stopLoss**: Harus lebih besar dari 0
- **takeProfit**: Harus lebih besar dari 0
- **entryReason**: Minimal 10 karakter
- **profitLoss**: Bisa positif (profit) atau negatif (loss)
- **profitLossPct**: Dihitung otomatis dari (exitPrice - entryPrice) / entryPrice * 100

---

## Calculated Fields

Field berikut dihitung secara otomatis:

- **profitLoss**: (exitPrice - entryPrice) * positionSize
- **profitLossPct**: ((exitPrice - entryPrice) / entryPrice) * 100

---

## Notes

- Semua field DateTime disimpan sebagai epoch timestamp (integer) di database
- Conversion dari/ke DateTime dilakukan di layer domain/entity
- Field `additionalNotes` bersifat opsional untuk fleksibilitas user
- Field `createdAt` dan `updatedAt` dikelola secara otomatis oleh database layer

---

**Dokumen ini akan menjadi acuan dalam pembuatan Entity, Model, dan Database Schema di layer Domain dan Data.**