# TradeTrackr - Data Schema Specification

Dokumen ini menjelaskan struktur data yang diharapkan untuk jurnal trading di aplikasi TradeTrackr. Struktur ini disesuaikan dengan format data yang ditemukan pada laporan trade (seperti pada `example_data.html`) dan akan menjadi dasar pembuatan entity, model, dan database schema.

---

## Trade Entry Data Schema

### Field Definitions

| Field Name     | Data Type | Required | Description                                   | Sample Value             |
|----------------|-----------|----------|-----------------------------------------------|--------------------------|
| id             | String    | Yes      | Unique identifier (ID dari platform/UUID)     | "W5508780760662777"      |
| symbol         | String    | Yes      | Nama instrumen atau aset (Symbol)             | "NDX100"                 |
| openTime       | DateTime  | Yes      | Tanggal dan waktu masuk posisi (Open Time)    | 2026-01-02 15:46:53      |
| closeTime      | DateTime  | Yes      | Tanggal dan waktu keluar posisi (Close Time)  | 2026-01-02 15:52:00      |
| volume         | Double    | Yes      | Ukuran posisi atau lot (Volume)               | 0.01                     |
| side           | String    | Yes      | Jenis transaksi (BUY/SELL)                    | "SELL"                   |
| tradeStatus    | String    | Yes      | Status posisi (Open/Close)                    | "Close"                  |
| openPrice      | Double    | Yes      | Harga saat masuk posisi (Open Price)          | 25376.74                 |
| closePrice     | Double    | Yes      | Harga saat keluar posisi (Close Price)        | 25275.78                 |
| stopLoss       | Double    | Yes      | Level stop loss yang ditetapkan               | 25416.92                 |
| takeProfit     | Double    | Yes      | Level take profit yang ditetapkan             | 25276.55                 |
| swap           | Double    | No       | Biaya inap (Swap)                             | 0.00                     |
| commission     | Double    | No       | Biaya komisi transaksi                        | 0.00                     |
| profit         | Double    | Yes      | Total keuntungan/kerugian bersih (Profit)     | 20.19                    |
| profitPercent  | Double    | No       | Persentase keuntungan atau kerugian           | 0.40                     |
| exitReason     | String    | Yes      | Alasan posisi ditutup (TP, SL, User, dll)     | "TP"                     |
| entryReason    | String    | No       | Strategi atau alasan masuk trade (Journaling) | "Breakout Structure"     |
| notes          | String    | No       | Catatan tambahan (psikologi, emosi, kondisi)  | "Good trade execution"   |
| createdAt      | DateTime  | Yes      | Timestamp saat data dibuat di database        | 2026-01-04 15:05:00      |
| updatedAt      | DateTime  | No       | Timestamp saat data terakhir diupdate         | 2026-01-04 15:10:00      |

---

## Enums

### Side (Transaction Type)

- **BUY** - Membuka posisi long
- **SELL** - Membuka posisi short

### Trade Status

- **Open** - Posisi masih berjalan / belum ditutup
- **Close** - Posisi sudah selesai / sudah ditutup

### Exit Reason

- **TP** - Take Profit hit
- **SL** - Stop Loss hit
- **User** - Manual close by user
- **Other** - Alasan lainnya (seperti Margin Call, Expired, dll)

---

## Sample Data Entry

Berikut adalah contoh lengkap satu entry data jurnal trading:

```json
{
  "id": "W5508780760662777",
  "symbol": "NDX100",
  "openTime": "2026-01-02T15:46:53Z",
  "closeTime": "2026-01-02T15:52:00Z",
  "volume": 0.01,
  "side": "SELL",
  "tradeStatus": "Close",
  "openPrice": 25376.74,
  "closePrice": 25275.78,
  "stopLoss": 25416.92,
  "takeProfit": 25276.55,
  "swap": 0.00,
  "commission": 0.00,
  "profit": 20.19,
  "profitPercent": 0.40,
  "exitReason": "TP",
  "entryReason": "Strategy A",
  "notes": "Fast TP",
  "createdAt": "2026-01-04T07:11:31Z",
  "updatedAt": "2026-01-04T07:11:31Z"
}
```

---

## Database Table Schema (SQL Equivalent)

```sql
CREATE TABLE trades (
  id TEXT PRIMARY KEY NOT NULL,
  symbol TEXT NOT NULL,
  open_time INTEGER NOT NULL,
  close_time INTEGER NOT NULL,
  volume REAL NOT NULL,
  side TEXT NOT NULL,
  trade_status TEXT NOT NULL,
  open_price REAL NOT NULL,
  close_price REAL NOT NULL,
  stop_loss REAL NOT NULL,
  take_profit REAL NOT NULL,
  swap REAL NOT NULL DEFAULT 0.0,
  commission REAL NOT NULL DEFAULT 0.0,
  profit REAL NOT NULL,
  profit_percent REAL,
  exit_reason TEXT NOT NULL,
  entry_reason TEXT,
  notes TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER
);
```

---

## Validations

- **id**: Harus ada, bisa berupa ID platform atau UUID
- **openTime**: Tidak boleh di masa depan
- **closeTime**: Harus lebih besar atau sama dengan openTime
- **symbol**: Tidak boleh kosong
- **side**: Harus "BUY" atau "SELL"
- **tradeStatus**: Harus "Open" atau "Close"
- **volume**: Harus lebih besar dari 0
- **openPrice**: Harus lebih besar dari 0
- **closePrice**: Harus lebih besar dari 0

---

## Calculated Fields (Optional)

- **profit**: Biasanya didapat langsung dari data, namun rumusnya: `((closePrice - openPrice) * volume * contractSize) + swap + commission` (tergantung instrumen).
- **profitPercent**: `((closePrice - openPrice) / openPrice) * 100` (untuk Buy) atau sebaliknya untuk Sell.

---

## Notes

- Semua field DateTime disimpan sebagai epoch timestamp (integer) di database.
- Conversion dari/ke DateTime dilakukan di layer domain/entity.
- Field `entryReason` dan `notes` diisi manual oleh user untuk keperluan jurnal.
- Data dari `example_data.html` dapat di-import langsung ke schema ini.
