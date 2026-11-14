-- ancient-dynasties-api — Mesopotamia seed data
-- Hand-curated starting corpus. Years are integers, BCE as negative.
-- Reign dates for 3rd millennium BCE are approximate (Middle Chronology).
--
-- Dynasties included:
--   * Akkadian Empire (c.2334 - c.2154 BCE)
--   * Third Dynasty of Ur ("Ur III", c.2112 - c.2004 BCE)
--   * Old Babylonian / 1st Dynasty of Babylon (c.1894 - c.1595 BCE)
--   * Neo-Babylonian (c.626 - c.539 BCE)

BEGIN;

-- ---------------------------------------------------------------------------
-- CIVILIZATION
-- ---------------------------------------------------------------------------
INSERT INTO civilizations (slug, name, region, era_start_year, era_end_year, description) VALUES
('mesopotamia', 'Mesopotamia', 'Tigris-Euphrates river system (modern Iraq, parts of Syria, Turkey, Iran)', -3500, -539,
 'The cradle of early civilisation. Home to successive Sumerian, Akkadian, Babylonian and Assyrian polities from the late 4th millennium BCE until the Persian conquest in 539 BCE.');

-- ---------------------------------------------------------------------------
-- DYNASTIES
-- ---------------------------------------------------------------------------
INSERT INTO dynasties (civilization_id, slug, name, founder_name, start_year, end_year, description) VALUES
((SELECT id FROM civilizations WHERE slug='mesopotamia'), 'akkadian', 'Akkadian Empire', 'Sargon of Akkad', -2334, -2154,
 'First known empire in history, founded by Sargon of Akkad, ruling over a unified Mesopotamia and extending influence from the Mediterranean to the Persian Gulf.'),
((SELECT id FROM civilizations WHERE slug='mesopotamia'), 'ur-iii', 'Third Dynasty of Ur', 'Ur-Nammu', -2112, -2004,
 'A Sumerian revival after the collapse of Akkad. Centralised bureaucratic state based at Ur, known for the Code of Ur-Nammu and the great Ziggurat of Ur.'),
((SELECT id FROM civilizations WHERE slug='mesopotamia'), 'old-babylonian', 'Old Babylonian (1st Dynasty of Babylon)', 'Sumu-abum', -1894, -1595,
 'Amorite dynasty that raised Babylon from a small city to the dominant power in Mesopotamia. Peaked under Hammurabi; ended with the Hittite sack of Babylon.'),
((SELECT id FROM civilizations WHERE slug='mesopotamia'), 'neo-babylonian', 'Neo-Babylonian Empire', 'Nabopolassar', -626, -539,
 'The final flowering of Babylonian power. Overthrew the Assyrian Empire, rebuilt Babylon on a monumental scale, and fell to Cyrus the Great of Persia.');

-- ---------------------------------------------------------------------------
-- RULERS
-- Inserted in reign order. Self-references (predecessor/successor/father) are
-- patched up in a second pass at the bottom of this file.
-- ---------------------------------------------------------------------------

-- Akkadian Empire
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='akkadian'), 'sargon-of-akkad', 'Sargon of Akkad', 'Šarru-kīn', -2334, -2279, TRUE,
 'Founder of the Akkadian Empire. United the Sumerian city-states under a single rule and launched the first known imperial administration.'),
((SELECT id FROM dynasties WHERE slug='akkadian'), 'rimush', 'Rimush', 'Rīmuš', -2278, -2270, TRUE,
 'Second king of the Akkadian Empire. Son of Sargon. Suppressed widespread revolts in the Sumerian south.'),
((SELECT id FROM dynasties WHERE slug='akkadian'), 'manishtushu', 'Manishtushu', 'Man-ištūšu', -2269, -2255, TRUE,
 'Third Akkadian king. Elder brother of Rimush. Known for maritime expeditions in the Persian Gulf.'),
((SELECT id FROM dynasties WHERE slug='akkadian'), 'naram-sin', 'Naram-Sin of Akkad', 'Narām-Sîn', -2254, -2218, TRUE,
 'Fourth and most celebrated Akkadian king. Grandson of Sargon. First Mesopotamian ruler to claim divine status within his own lifetime. Depicted on the Victory Stele of Naram-Sin.'),
((SELECT id FROM dynasties WHERE slug='akkadian'), 'shar-kali-sharri', 'Shar-kali-sharri', 'Šar-kali-šarrī', -2217, -2193, TRUE,
 'Last fully attested Akkadian king. Reign marked by invasions of Gutians and Elamites that preceded the empire''s collapse.');

-- Third Dynasty of Ur
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='ur-iii'), 'ur-nammu', 'Ur-Nammu', 'Ur-Namma', -2112, -2095, TRUE,
 'Founder of the Third Dynasty of Ur. Commissioned the earliest surviving law code (the Code of Ur-Nammu) and the great Ziggurat of Ur.'),
((SELECT id FROM dynasties WHERE slug='ur-iii'), 'shulgi', 'Shulgi', 'Šulgi', -2094, -2047, TRUE,
 'Second king of Ur III. Son of Ur-Nammu. Reformed the Sumerian state into a centralised bureaucracy; deified during his lifetime; composed hymns still extant.'),
((SELECT id FROM dynasties WHERE slug='ur-iii'), 'amar-sin', 'Amar-Sin', 'Amar-Sîn', -2046, -2038, TRUE,
 'Third king of Ur III. Son of Shulgi. Known chiefly from administrative tablets.'),
((SELECT id FROM dynasties WHERE slug='ur-iii'), 'shu-sin', 'Shu-Sin', 'Šū-Sîn', -2037, -2029, TRUE,
 'Fourth king of Ur III. Younger son of Shulgi. Built the Amorite Wall to defend against nomadic incursions.'),
((SELECT id FROM dynasties WHERE slug='ur-iii'), 'ibbi-sin', 'Ibbi-Sin', 'Ibbi-Sîn', -2028, -2004, TRUE,
 'Last king of Ur III. Son of Shu-Sin. Oversaw the collapse of the dynasty amid Elamite invasions and the fall of Ur.');

-- Old Babylonian (1st Dynasty of Babylon)
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='old-babylonian'), 'sumu-abum', 'Sumu-abum', 'Sumu-abum', -1894, -1881, TRUE,
 'Founder of the 1st Dynasty of Babylon. Amorite chief who established Babylon as an independent city-kingdom.'),
((SELECT id FROM dynasties WHERE slug='old-babylonian'), 'hammurabi', 'Hammurabi', 'Ḫammu-rāpi', -1792, -1750, TRUE,
 'Sixth king of the 1st Dynasty of Babylon. Unified Mesopotamia through diplomacy and conquest; promulgated the Code of Hammurabi, one of the earliest and most complete written legal codes.'),
((SELECT id FROM dynasties WHERE slug='old-babylonian'), 'samsu-iluna', 'Samsu-iluna', 'Samsu-iluna', -1749, -1712, TRUE,
 'Son and successor of Hammurabi. Faced revolts and the gradual loss of southern Mesopotamia; reign saw the beginning of the decline of the dynasty.');

-- Neo-Babylonian Empire
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='neo-babylonian'), 'nabopolassar', 'Nabopolassar', 'Nabû-apla-uṣur', -626, -605, FALSE,
 'Founder of the Neo-Babylonian Empire. Chaldean general who broke from Assyrian rule and allied with the Medes to destroy Nineveh in 612 BCE.'),
((SELECT id FROM dynasties WHERE slug='neo-babylonian'), 'nebuchadnezzar-ii', 'Nebuchadnezzar II', 'Nabû-kudurri-uṣur', -605, -562, FALSE,
 'Second and greatest Neo-Babylonian king. Son of Nabopolassar. Rebuilt Babylon on a monumental scale (Ishtar Gate, Hanging Gardens tradition), destroyed Jerusalem in 587 BCE and initiated the Babylonian Exile.'),
((SELECT id FROM dynasties WHERE slug='neo-babylonian'), 'nabonidus', 'Nabonidus', 'Nabû-naʾid', -556, -539, FALSE,
 'Last king of the Neo-Babylonian Empire. Spent years at the oasis of Tayma; left his son Belshazzar as co-regent in Babylon. Deposed when Cyrus the Great of Persia took Babylon without battle in 539 BCE.');

-- ---------------------------------------------------------------------------
-- SECOND-PASS: wire up predecessor / successor / father references
-- ---------------------------------------------------------------------------

-- Akkadian lineage: Sargon → Rimush → Manishtushu → Naram-Sin → Shar-kali-sharri
UPDATE rulers SET successor_id   = (SELECT id FROM rulers WHERE slug='rimush')             WHERE slug='sargon-of-akkad';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='sargon-of-akkad'),
                  father_id      = (SELECT id FROM rulers WHERE slug='sargon-of-akkad'),
                  successor_id   = (SELECT id FROM rulers WHERE slug='manishtushu')        WHERE slug='rimush';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='rimush'),
                  father_id      = (SELECT id FROM rulers WHERE slug='sargon-of-akkad'),
                  successor_id   = (SELECT id FROM rulers WHERE slug='naram-sin')          WHERE slug='manishtushu';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='manishtushu'),
                  father_id      = (SELECT id FROM rulers WHERE slug='manishtushu'),
                  successor_id   = (SELECT id FROM rulers WHERE slug='shar-kali-sharri')   WHERE slug='naram-sin';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='naram-sin'),
                  father_id      = (SELECT id FROM rulers WHERE slug='naram-sin')          WHERE slug='shar-kali-sharri';

-- Ur III lineage: Ur-Nammu → Shulgi → Amar-Sin → Shu-Sin → Ibbi-Sin
UPDATE rulers SET successor_id   = (SELECT id FROM rulers WHERE slug='shulgi')             WHERE slug='ur-nammu';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='ur-nammu'),
                  father_id      = (SELECT id FROM rulers WHERE slug='ur-nammu'),
                  successor_id   = (SELECT id FROM rulers WHERE slug='amar-sin')           WHERE slug='shulgi';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='shulgi'),
                  father_id      = (SELECT id FROM rulers WHERE slug='shulgi'),
                  successor_id   = (SELECT id FROM rulers WHERE slug='shu-sin')            WHERE slug='amar-sin';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='amar-sin'),
                  father_id      = (SELECT id FROM rulers WHERE slug='shulgi'),
                  successor_id   = (SELECT id FROM rulers WHERE slug='ibbi-sin')           WHERE slug='shu-sin';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='shu-sin'),
                  father_id      = (SELECT id FROM rulers WHERE slug='shu-sin')            WHERE slug='ibbi-sin';

-- Old Babylonian: Sumu-abum → ... → Hammurabi → Samsu-iluna (direct father-son)
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='hammurabi'),
                  father_id      = (SELECT id FROM rulers WHERE slug='hammurabi')          WHERE slug='samsu-iluna';

-- Neo-Babylonian: Nabopolassar → Nebuchadnezzar II → ... → Nabonidus
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='nabopolassar'),
                  father_id      = (SELECT id FROM rulers WHERE slug='nabopolassar')       WHERE slug='nebuchadnezzar-ii';
UPDATE rulers SET successor_id   = (SELECT id FROM rulers WHERE slug='nebuchadnezzar-ii')  WHERE slug='nabopolassar';

-- ---------------------------------------------------------------------------
-- PLACES
-- ---------------------------------------------------------------------------
INSERT INTO places (slug, name, modern_name, latitude, longitude, era_start_year, era_end_year, description) VALUES
('akkad', 'Akkad', 'Location uncertain (central Iraq)', NULL, NULL, -2334, -2154, 'Capital of the Akkadian Empire. Its exact location is one of the great unresolved questions of Near Eastern archaeology.'),
('ur', 'Ur', 'Tell el-Muqayyar', 30.96267, 46.10306, -3800, -500, 'Major Sumerian city on the Euphrates. Capital of the Third Dynasty of Ur. Site of the great Ziggurat built by Ur-Nammu.'),
('babylon', 'Babylon', 'Hillah', 32.54222, 44.42111, -1894, -539, 'City on the Euphrates that became the political and cultural heart of successive Mesopotamian empires from Hammurabi onwards.'),
('nineveh', 'Nineveh', 'Mosul', 36.35972, 43.14944, -700, -612, 'Last capital of the Assyrian Empire. Sacked in 612 BCE by a Medo-Babylonian coalition.');

-- ruler <-> place associations (capitals and burial / notable sites)
INSERT INTO rulers_places (ruler_id, place_id, context) VALUES
((SELECT id FROM rulers WHERE slug='sargon-of-akkad'),   (SELECT id FROM places WHERE slug='akkad'),  'capital'),
((SELECT id FROM rulers WHERE slug='naram-sin'),         (SELECT id FROM places WHERE slug='akkad'),  'capital'),
((SELECT id FROM rulers WHERE slug='ur-nammu'),          (SELECT id FROM places WHERE slug='ur'),     'capital'),
((SELECT id FROM rulers WHERE slug='shulgi'),            (SELECT id FROM places WHERE slug='ur'),     'capital'),
((SELECT id FROM rulers WHERE slug='hammurabi'),         (SELECT id FROM places WHERE slug='babylon'),'capital'),
((SELECT id FROM rulers WHERE slug='nebuchadnezzar-ii'), (SELECT id FROM places WHERE slug='babylon'),'capital'),
((SELECT id FROM rulers WHERE slug='nabonidus'),         (SELECT id FROM places WHERE slug='babylon'),'capital');

-- ---------------------------------------------------------------------------
-- EVENTS
-- ---------------------------------------------------------------------------
INSERT INTO events (slug, name, event_type, year, description) VALUES
('fall-of-nineveh', 'Fall of Nineveh', 'battle', -612,
 'The Assyrian capital Nineveh was sacked by a coalition of the Medes under Cyaxares and the Babylonians under Nabopolassar, marking the end of the Assyrian Empire.'),
('destruction-of-jerusalem', 'Destruction of Jerusalem', 'battle', -587,
 'Nebuchadnezzar II destroyed the First Temple and the city of Jerusalem, deporting the surviving Judean elite to Babylon and initiating the Babylonian Exile.'),
('fall-of-babylon', 'Fall of Babylon', 'battle', -539,
 'Cyrus the Great of Persia entered Babylon, ending the Neo-Babylonian Empire and incorporating Mesopotamia into the Achaemenid Empire.'),
('victory-stele-of-naram-sin', 'Victory over the Lullubi (Victory Stele of Naram-Sin)', 'battle', -2250,
 'Naram-Sin defeated the Lullubi mountain people and commissioned the Victory Stele to commemorate the campaign; the earliest known depiction of a ruler as a divine figure.');

INSERT INTO rulers_events (ruler_id, event_id, role) VALUES
((SELECT id FROM rulers WHERE slug='nabopolassar'),      (SELECT id FROM events WHERE slug='fall-of-nineveh'),        'victor'),
((SELECT id FROM rulers WHERE slug='nebuchadnezzar-ii'), (SELECT id FROM events WHERE slug='destruction-of-jerusalem'),'victor'),
((SELECT id FROM rulers WHERE slug='nabonidus'),         (SELECT id FROM events WHERE slug='fall-of-babylon'),         'defeated'),
((SELECT id FROM rulers WHERE slug='naram-sin'),         (SELECT id FROM events WHERE slug='victory-stele-of-naram-sin'),'victor');

COMMIT;
