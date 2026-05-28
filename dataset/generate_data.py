"""
Retail Sales SQL Portfolio — Large Dataset Generator
Generates realistic INSERT statements for SQL Server (T-SQL)
Output: 02_insert_data.sql
  - 10  stores
  - 50  products
  - 500 customers
  - 3,000 orders  (2022–2024)
  - ~7,500 order items
"""

import random
from datetime import date, timedelta

random.seed(42)  # reproducible output

# ── helpers ────────────────────────────────────────────────────────────────

def rand_date(start: date, end: date) -> date:
    return start + timedelta(days=random.randint(0, (end - start).days))

def esc(s: str) -> str:
    return s.replace("'", "''")

# ── reference data ─────────────────────────────────────────────────────────

REGIONS = {
    "East":  [("New York","New York"), ("Boston","Massachusetts"), ("Philadelphia","Pennsylvania"),
               ("Newark","New Jersey"), ("Hartford","Connecticut")],
    "North": [("Chicago","Illinois"), ("Minneapolis","Minnesota"), ("Detroit","Michigan"),
               ("Milwaukee","Wisconsin"), ("Columbus","Ohio")],
    "South": [("Dallas","Texas"), ("Miami","Florida"), ("Atlanta","Georgia"),
               ("Houston","Texas"), ("Charlotte","North Carolina")],
    "West":  [("Los Angeles","California"), ("Seattle","Washington"), ("Denver","Colorado"),
               ("Phoenix","Arizona"), ("Portland","Oregon")],
}

FIRST_NAMES_M = [
    "James","John","Robert","Michael","William","David","Richard","Joseph","Thomas","Charles",
    "Christopher","Daniel","Matthew","Anthony","Donald","Mark","Paul","Steven","Andrew","Kenneth",
    "Joshua","Kevin","Brian","George","Timothy","Ronald","Edward","Jason","Jeffrey","Ryan",
    "Jacob","Gary","Nicholas","Eric","Jonathan","Stephen","Larry","Justin","Scott","Brandon",
    "Benjamin","Samuel","Frank","Raymond","Gregory","Patrick","Alexander","Jack","Dennis","Jerry",
]
FIRST_NAMES_F = [
    "Mary","Patricia","Jennifer","Linda","Barbara","Elizabeth","Susan","Jessica","Sarah","Karen",
    "Lisa","Nancy","Betty","Margaret","Sandra","Ashley","Dorothy","Kimberly","Emily","Donna",
    "Michelle","Carol","Amanda","Melissa","Deborah","Stephanie","Rebecca","Sharon","Laura","Cynthia",
    "Kathleen","Amy","Angela","Shirley","Anna","Brenda","Pamela","Emma","Nicole","Helen",
    "Samantha","Katherine","Christine","Debra","Rachel","Carolyn","Janet","Catherine","Maria","Heather",
]
LAST_NAMES = [
    "Smith","Johnson","Williams","Brown","Jones","Garcia","Miller","Davis","Rodriguez","Martinez",
    "Hernandez","Lopez","Gonzalez","Wilson","Anderson","Thomas","Taylor","Moore","Jackson","Martin",
    "Lee","Perez","Thompson","White","Harris","Sanchez","Clark","Ramirez","Lewis","Robinson",
    "Walker","Young","Allen","King","Wright","Scott","Torres","Nguyen","Hill","Flores",
    "Green","Adams","Nelson","Baker","Hall","Rivera","Campbell","Mitchell","Carter","Roberts",
    "Phillips","Evans","Turner","Parker","Collins","Edwards","Stewart","Morris","Murphy","Cook",
    "Rogers","Morgan","Peterson","Cooper","Reed","Bailey","Bell","Gomez","Kelly","Howard",
    "Ward","Cox","Diaz","Richardson","Wood","Watson","Brooks","Bennett","Gray","James",
    "Reyes","Cruz","Hughes","Price","Myers","Long","Foster","Sanders","Ross","Morales",
]

PRODUCTS = [
    # Electronics
    (1,  "Wireless Noise-Cancelling Headphones","Electronics","Audio",         189.99, 82.00),
    (2,  "Smart Watch Series X",               "Electronics","Wearables",     249.99, 105.00),
    (3,  "Portable Bluetooth Speaker",         "Electronics","Audio",          69.99,  27.00),
    (4,  "USB-C 9-in-1 Hub",                   "Electronics","Accessories",    59.99,  22.00),
    (5,  "4K HD Webcam",                        "Electronics","Accessories",    99.99,  42.00),
    (6,  "Mechanical Gaming Keyboard",          "Electronics","Accessories",   139.99,  58.00),
    (7,  "27-inch Monitor IPS",                 "Electronics","Displays",      329.99, 145.00),
    (8,  "Wireless Gaming Mouse",               "Electronics","Accessories",    79.99,  33.00),
    (9,  "Portable SSD 1TB",                    "Electronics","Storage",       109.99,  48.00),
    (10, "Smart Home Hub",                      "Electronics","Smart Home",    149.99,  62.00),
    # Clothing
    (11, "Men's Performance Polo Shirt",        "Clothing","Tops",              34.99,  10.00),
    (12, "Women's Waterproof Jacket",           "Clothing","Outerwear",         99.99,  38.00),
    (13, "Men's Running Shoes Pro",             "Clothing","Footwear",         129.99,  52.00),
    (14, "Women's Athletic Leggings",           "Clothing","Bottoms",           49.99,  16.00),
    (15, "Unisex Sports T-Shirt",               "Clothing","Tops",              24.99,   7.00),
    (16, "Men's Winter Parka",                  "Clothing","Outerwear",        159.99,  65.00),
    (17, "Women's Running Shoes",               "Clothing","Footwear",         119.99,  48.00),
    (18, "Classic Denim Jeans",                 "Clothing","Bottoms",           59.99,  20.00),
    (19, "Merino Wool Sweater",                 "Clothing","Tops",              79.99,  28.00),
    (20, "Compression Socks 3-Pack",            "Clothing","Accessories",       19.99,   5.50),
    # Home & Garden
    (21, "Espresso Coffee Maker",               "Home & Garden","Kitchen",     129.99,  52.00),
    (22, "HEPA Air Purifier 500sqft",           "Home & Garden","Appliances",  179.99,  75.00),
    (23, "Professional Knife Set 8-Piece",      "Home & Garden","Kitchen",      89.99,  34.00),
    (24, "Smart LED Desk Lamp",                 "Home & Garden","Lighting",     54.99,  20.00),
    (25, "Bamboo Storage Organizer Set",        "Home & Garden","Storage",      39.99,  13.00),
    (26, "Ceramic Plant Pot Collection",        "Home & Garden","Garden",       34.99,  10.00),
    (27, "Robot Vacuum Cleaner",                "Home & Garden","Appliances",  299.99, 130.00),
    (28, "Instant Pot 8-Quart",                 "Home & Garden","Kitchen",     119.99,  50.00),
    (29, "Memory Foam Pillow Set",              "Home & Garden","Bedroom",      49.99,  17.00),
    (30, "Blackout Curtains Pair",              "Home & Garden","Bedroom",      44.99,  15.00),
    # Sports & Outdoors
    (31, "Premium Yoga Mat 6mm",                "Sports & Outdoors","Fitness",  39.99,  12.00),
    (32, "Resistance Bands Set 5-Level",        "Sports & Outdoors","Fitness",  24.99,   7.00),
    (33, "Insulated Water Bottle 32oz",         "Sports & Outdoors","Hydration",29.99,   9.00),
    (34, "Weightlifting Gloves Pro",            "Sports & Outdoors","Fitness",  22.99,   7.00),
    (35, "Adjustable Jump Rope",                "Sports & Outdoors","Fitness",  16.99,   5.00),
    (36, "Deep Tissue Foam Roller",             "Sports & Outdoors","Recovery", 39.99,  12.00),
    (37, "Trekking Poles Carbon Fibre",         "Sports & Outdoors","Outdoor",  69.99,  27.00),
    (38, "Hydration Running Vest",              "Sports & Outdoors","Outdoor",  59.99,  22.00),
    (39, "Adjustable Dumbbells Set",            "Sports & Outdoors","Fitness", 249.99, 105.00),
    (40, "Pull-Up Bar Doorframe",               "Sports & Outdoors","Fitness",  34.99,  11.00),
    # Food & Beverages
    (41, "Whey Protein Powder 5lb",             "Food & Beverages","Supplements",54.99, 22.00),
    (42, "Organic Green Tea 100 Bags",          "Food & Beverages","Tea & Coffee",16.99, 5.00),
    (43, "Premium Roasted Mixed Nuts 2lb",      "Food & Beverages","Snacks",    24.99,   8.50),
    (44, "Raw Wildflower Honey 32oz",           "Food & Beverages","Pantry",    18.99,   6.00),
    (45, "Protein Energy Bars 24-Pack",         "Food & Beverages","Supplements",29.99, 11.00),
    (46, "Single-Origin Coffee Beans 2lb",      "Food & Beverages","Tea & Coffee",27.99, 10.00),
    (47, "Collagen Peptides Powder",            "Food & Beverages","Supplements",44.99, 17.00),
    (48, "Electrolyte Drink Mix 60 Packs",      "Food & Beverages","Supplements",34.99, 12.00),
    (49, "Organic Chia Seeds 2lb",              "Food & Beverages","Pantry",    14.99,   4.50),
    (50, "Dark Chocolate Almonds 1lb",          "Food & Beverages","Snacks",    12.99,   4.00),
]

STORES = [
    (1,  "Downtown NY Flagship",   "New York",      "New York",       "East",  "2016-03-15"),
    (2,  "Boston City Store",      "Boston",        "Massachusetts",  "East",  "2017-06-01"),
    (3,  "Philadelphia Hub",       "Philadelphia",  "Pennsylvania",   "East",  "2018-09-20"),
    (4,  "Chicago Central",        "Chicago",       "Illinois",       "North", "2015-11-10"),
    (5,  "Minneapolis Midtown",    "Minneapolis",   "Minnesota",      "North", "2019-02-28"),
    (6,  "Dallas Flagship",        "Dallas",        "Texas",          "South", "2014-08-05"),
    (7,  "Miami Beach Store",      "Miami",         "Florida",        "South", "2016-01-25"),
    (8,  "Atlanta Express",        "Atlanta",       "Georgia",        "South", "2018-04-18"),
    (9,  "LA Westside",            "Los Angeles",   "California",     "West",  "2013-05-30"),
    (10, "Seattle Tech Hub",       "Seattle",       "Washington",     "West",  "2017-09-12"),
]

STATUSES = ["Completed"] * 75 + ["Cancelled"] * 10 + ["Returned"] * 10 + ["Pending"] * 5

# ── generation ─────────────────────────────────────────────────────────────

def build_customers(n=500):
    rows = []
    used_emails = set()
    cid = 1
    for _ in range(n):
        gender = random.choice(["Male", "Female"])
        first  = random.choice(FIRST_NAMES_M if gender == "Male" else FIRST_NAMES_F)
        last   = random.choice(LAST_NAMES)
        region = random.choice(list(REGIONS.keys()))
        city, state = random.choice(REGIONS[region])
        age    = random.randint(20, 65)
        joined = rand_date(date(2020, 1, 1), date(2024, 6, 30))

        base  = f"{first[0].lower()}.{esc(last).lower().replace(' ','')}"
        email = f"{base}{cid}@email.com"
        while email in used_emails:
            email = f"{base}{cid}x@email.com"
        used_emails.add(email)

        rows.append(
            f"({cid},'{esc(first)}','{esc(last)}','{email}',"
            f"'{esc(city)}','{esc(state)}','{region}','{gender}',{age},'{joined}')"
        )
        cid += 1
    return rows


def build_orders(n_customers=500, n_orders=3000):
    rows = []
    start, end = date(2022, 1, 1), date(2024, 12, 31)
    for oid in range(1, n_orders + 1):
        cid      = random.randint(1, n_customers)
        sid      = random.randint(1, 10)
        region   = [r for r, locs in REGIONS.items()
                    if any(loc[0] == STORES[sid-1][1] for loc in locs)]
        region   = region[0] if region else random.choice(list(REGIONS.keys()))
        odate    = rand_date(start, end)
        sdate    = odate + timedelta(days=random.randint(2, 7))
        status   = random.choice(STATUSES)
        rows.append(
            f"({oid},{cid},{sid},'{odate}','{sdate}','{status}','{region}')"
        )
    return rows


def build_order_items(n_orders=3000):
    rows = []
    iid = 1
    for oid in range(1, n_orders + 1):
        n_items = random.randint(1, 5)
        chosen  = random.sample(range(1, 51), n_items)
        for pid in chosen:
            prod     = PRODUCTS[pid - 1]
            price    = prod[5]  # unit_price
            qty      = random.randint(1, 4)
            discount = random.choice([0.00, 0.00, 0.00, 0.05, 0.10, 0.15, 0.20])
            rows.append(
                f"({iid},{oid},{pid},{qty},{price:.2f},{discount:.2f})"
            )
            iid += 1
    return rows


# ── write SQL file ──────────────────────────────────────────────────────────

def chunk(lst, size=500):
    for i in range(0, len(lst), size):
        yield lst[i:i + size]


def write_sql(path: str):
    customers   = build_customers(500)
    orders      = build_orders(500, 3000)
    order_items = build_order_items(3000)

    print(f"  Customers  : {len(customers)}")
    print(f"  Orders     : {len(orders)}")
    print(f"  Order items: {len(order_items)}")

    with open(path, "w", encoding="utf-8") as f:
        f.write("-- ============================================================\n")
        f.write("-- RETAIL SALES ANALYSIS - SAMPLE DATA (Large Dataset)\n")
        f.write(f"-- Customers: {len(customers)} | Orders: {len(orders)} | Items: {len(order_items)}\n")
        f.write("-- Run 01_create_schema.sql first\n")
        f.write("-- ============================================================\n\n")

        # Stores
        f.write("-- STORES\n")
        f.write("INSERT INTO stores VALUES\n")
        store_vals = [
            f"({s[0]},'{s[1]}','{s[2]}','{s[3]}','{s[4]}','{s[5]}')"
            for s in STORES
        ]
        f.write(",\n".join(store_vals) + ";\n\n")

        # Products
        f.write("-- PRODUCTS\n")
        prod_vals = [
            f"({p[0]},'{esc(p[1])}','{p[2]}','{p[3]}',{p[4]:.2f},{p[5]:.2f})"
            for p in PRODUCTS
        ]
        f.write("INSERT INTO products VALUES\n")
        f.write(",\n".join(prod_vals) + ";\n\n")

        # Customers (batches of 500)
        f.write("-- CUSTOMERS (500 rows)\n")
        for batch in chunk(customers, 500):
            f.write("INSERT INTO customers VALUES\n")
            f.write(",\n".join(batch) + ";\n\n")

        # Orders (batches of 500)
        f.write("-- ORDERS (3,000 rows)\n")
        for batch in chunk(orders, 500):
            f.write("INSERT INTO orders VALUES\n")
            f.write(",\n".join(batch) + ";\n\n")

        # Order items (batches of 500)
        f.write(f"-- ORDER ITEMS ({len(order_items):,} rows)\n")
        for batch in chunk(order_items, 500):
            f.write("INSERT INTO order_items VALUES\n")
            f.write(",\n".join(batch) + ";\n\n")

    print(f"\nWritten to: {path}")


if __name__ == "__main__":
    import os
    out = os.path.join(os.path.dirname(__file__), "02_insert_data.sql")
    print("Generating large retail dataset...")
    write_sql(out)
    print("Done.")
