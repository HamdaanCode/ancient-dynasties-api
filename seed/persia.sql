-- ancient-dynasties-api - Persia seed data
-- Hand-curated starting corpus. Years are integers, BCE as negative, CE as positive.
-- Achaemenid regnal dates follow the conventional academic chronology.
--
-- Dynasties included:
--   * Achaemenid Empire (550 - 330 BCE) - founded by Cyrus, ended by Alexander
--   * Parthian Empire (247 BCE - 224 CE) - Arsacid Iran
--   * Sasanian Empire (224 - 651 CE) - last pre-Islamic Persian empire

BEGIN;

-- ---------------------------------------------------------------------------
-- CIVILIZATION
-- ---------------------------------------------------------------------------
INSERT INTO civilizations (slug, name, region, era_start_year, era_end_year, description) VALUES
('persia', 'Ancient Persia', 'Iranian plateau and surrounding regions from the Indus to the Aegean', -550, 651,
 'From Cyrus the Great through to the Arab conquests, Persian empires dominated the world between the Mediterranean and India for more than a thousand years. This seed covers the Achaemenid, Parthian and Sasanian dynasties.');

-- ---------------------------------------------------------------------------
-- DYNASTIES
-- ---------------------------------------------------------------------------
INSERT INTO dynasties (civilization_id, slug, name, founder_name, start_year, end_year, description) VALUES
((SELECT id FROM civilizations WHERE slug='persia'), 'achaemenid', 'Achaemenid Empire', 'Cyrus the Great', -550, -330,
 'The first Persian empire and at its height the largest the ancient world had seen. Founded by Cyrus the Great, extended from the Balkans to the Indus by Darius I, and conquered by Alexander the Great after the Battle of Gaugamela.'),
((SELECT id FROM civilizations WHERE slug='persia'), 'parthian', 'Parthian Empire', 'Arsaces I', -247, 224,
 'Also known as the Arsacid Empire. Rose in north-eastern Iran after the collapse of Seleucid power, became Romes great eastern rival for three centuries, and was eventually overthrown from within by the Sasanians.'),
((SELECT id FROM civilizations WHERE slug='persia'), 'sasanian', 'Sasanian Empire', 'Ardashir I', 224, 651,
 'The last pre-Islamic Persian empire. Centralised the state around Zoroastrian orthodoxy, fought a long series of wars with Rome and later Byzantium, and fell to the Arab conquests after the Battle of al-Qadisiyyah.');

-- ---------------------------------------------------------------------------
-- RULERS
-- ---------------------------------------------------------------------------

-- Achaemenid
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'cyrus-the-great', 'Cyrus the Great', 'Kūruš (𐎤𐎢𐎽𐎢𐏁)', -559, -530, FALSE,
 'Founder of the Achaemenid Empire. Conquered the Medes, Lydians and Neo-Babylonians to create an empire stretching from the Aegean to the Indus. Remembered in the Cyrus Cylinder and in the Hebrew Bible for freeing the Jews from Babylonian exile.'),
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'cambyses-ii', 'Cambyses II', 'Kambūjiya (𐎣𐎲𐎢𐎪𐎡𐎹)', -530, -522, FALSE,
 'Son and successor of Cyrus. Conquered Egypt in 525 BCE at the Battle of Pelusium, adding the last great independent power of the Near East. Died under contested circumstances on his return home.'),
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'darius-i', 'Darius I', 'Dārayavahuš (𐎭𐎠𐎼𐎹𐎺𐎢𐏁)', -522, -486, FALSE,
 'Third Achaemenid king, took the throne through a palace coup after the death of Cambyses II. Reorganised the empire into satrapies, standardised coinage, built the Royal Road, and began construction of Persepolis. Launched the first invasion of Greece.'),
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'xerxes-i', 'Xerxes I', 'Xšayāršā (𐎧𐏁𐎹𐎠𐎼𐏁𐎠)', -486, -465, FALSE,
 'Son of Darius I. Led the second Persian invasion of Greece in 480 BCE, sacking Athens but losing his fleet at Salamis and his army at Plataea the following year. Completed much of Persepolis before his assassination.'),
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'artaxerxes-i', 'Artaxerxes I', 'Artaxšaça (𐎠𐎼𐎫𐎧𐏁𐏂𐎠)', -465, -424, FALSE,
 'Son of Xerxes I. Negotiated the Peace of Callias with Athens around 449 BCE, ending open hostilities with the Greeks for a generation. Hosted Jewish returnees to Jerusalem including Ezra and Nehemiah.'),
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'artaxerxes-ii', 'Artaxerxes II', 'Artaxšaça (𐎠𐎼𐎫𐎧𐏁𐏂𐎠)', -404, -358, FALSE,
 'Longest-reigning Achaemenid, ruling for 46 years. Defeated his rebelling brother Cyrus the Younger at Cunaxa in 401 BCE, after which Xenophons Ten Thousand retreated to the Black Sea. Reign was dominated by satrapal revolts and intrigues.'),
((SELECT id FROM dynasties WHERE slug='achaemenid'), 'darius-iii', 'Darius III', 'Dārayavahuš (𐎭𐎠𐎼𐎹𐎺𐎢𐏁)', -336, -330, FALSE,
 'Last Achaemenid king. Lost three set-piece battles to Alexander the Great at Granicus, Issus and finally Gaugamela in 331 BCE. Fled east and was murdered by his own satrap Bessus, ending the Achaemenid Empire.');

-- Parthian
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='parthian'), 'arsaces-i', 'Arsaces I', 'Aršak', -247, -217, TRUE,
 'Founder of the Parthian (Arsacid) dynasty. A chieftain of the nomadic Parni who invaded the Seleucid satrapy of Parthia and established an independent kingdom that would become a great empire.'),
((SELECT id FROM dynasties WHERE slug='parthian'), 'mithridates-i', 'Mithridates I', 'Mihrdāt', -171, -132, FALSE,
 'The real empire-builder of the Parthian state. Took Media and Mesopotamia from the Seleucids, captured Babylon and Seleucia, and adopted the title King of Kings in deliberate echo of the Achaemenids.');

-- Sasanian
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='sasanian'), 'khosrow-i', 'Khosrow I', 'Khosrow Anushirvan', 531, 579, FALSE,
 'Greatest Sasanian king, also known as Anushirvan the Just. Reformed taxation and the army, patronised a flowering of Persian learning that preserved Greek philosophy, and fought a long war of attrition with Justinians Byzantium.');

-- ---------------------------------------------------------------------------
-- SECOND PASS: predecessor / successor / father wiring
-- ---------------------------------------------------------------------------

-- Achaemenid line: Cyrus - Cambyses (son) - [Bardiya, skipped] - Darius I (usurper, distant cousin) - Xerxes (son) - Artaxerxes I (son)
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='cambyses-ii') WHERE slug='cyrus-the-great';
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='cyrus-the-great'),
                  predecessor_id = (SELECT id FROM rulers WHERE slug='cyrus-the-great'),
                  successor_id = (SELECT id FROM rulers WHERE slug='darius-i') WHERE slug='cambyses-ii';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='cambyses-ii'),
                  successor_id = (SELECT id FROM rulers WHERE slug='xerxes-i') WHERE slug='darius-i';
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='darius-i'),
                  predecessor_id = (SELECT id FROM rulers WHERE slug='darius-i'),
                  successor_id = (SELECT id FROM rulers WHERE slug='artaxerxes-i') WHERE slug='xerxes-i';
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='xerxes-i'),
                  predecessor_id = (SELECT id FROM rulers WHERE slug='xerxes-i') WHERE slug='artaxerxes-i';
-- Artaxerxes II and Darius III: multiple generations and claimants skipped between them, leaving the links null is honest.

-- ---------------------------------------------------------------------------
-- PLACES
-- ---------------------------------------------------------------------------
INSERT INTO places (slug, name, modern_name, latitude, longitude, era_start_year, era_end_year, description) VALUES
('pasargadae', 'Pasargadae', 'Pasargad, Fars province, Iran', 30.19417, 53.17, -559, -330, 'The first capital of the Achaemenid Empire, built by Cyrus the Great on the plain where he defeated the Medes. Site of Cyrus''s tomb, still standing today.'),
('persepolis', 'Persepolis', 'Persepolis archaeological site, Fars, Iran', 29.93583, 52.89111, -515, -330, 'Ceremonial capital of the Achaemenid Empire, begun by Darius I around 515 BCE. Known for its vast Apadana audience hall and reliefs of tribute-bearing delegations. Burned by Alexander in 330 BCE.'),
('susa', 'Susa', 'Shush, Khuzestan, Iran', 32.19056, 48.25944, -4000, 1200, 'Ancient Elamite city reused by the Achaemenids as their administrative capital. One of the oldest continuously inhabited cities in the world. Features in the Book of Esther as Shushan.'),
('ctesiphon', 'Ctesiphon', 'near Baghdad, Iraq', 33.09139, 44.58056, -140, 651, 'Capital of the Parthian and Sasanian empires, on the Tigris south-east of modern Baghdad. Site of the Taq Kasra, the largest unreinforced brick vault surviving from the ancient world.');

INSERT INTO rulers_places (ruler_id, place_id, context) VALUES
((SELECT id FROM rulers WHERE slug='cyrus-the-great'),  (SELECT id FROM places WHERE slug='pasargadae'),  'capital and tomb'),
((SELECT id FROM rulers WHERE slug='cambyses-ii'),      (SELECT id FROM places WHERE slug='pasargadae'),  'capital'),
((SELECT id FROM rulers WHERE slug='darius-i'),         (SELECT id FROM places WHERE slug='persepolis'),  'builder'),
((SELECT id FROM rulers WHERE slug='darius-i'),         (SELECT id FROM places WHERE slug='susa'),        'administrative capital'),
((SELECT id FROM rulers WHERE slug='xerxes-i'),         (SELECT id FROM places WHERE slug='persepolis'),  'builder'),
((SELECT id FROM rulers WHERE slug='artaxerxes-i'),     (SELECT id FROM places WHERE slug='susa'),        'administrative capital'),
((SELECT id FROM rulers WHERE slug='darius-iii'),       (SELECT id FROM places WHERE slug='persepolis'),  'capital'),
((SELECT id FROM rulers WHERE slug='mithridates-i'),    (SELECT id FROM places WHERE slug='ctesiphon'),   'capital'),
((SELECT id FROM rulers WHERE slug='khosrow-i'),        (SELECT id FROM places WHERE slug='ctesiphon'),   'capital');

-- ---------------------------------------------------------------------------
-- EVENTS
-- ---------------------------------------------------------------------------
INSERT INTO events (slug, name, event_type, year, description) VALUES
('battle-of-thymbra', 'Battle of Thymbra', 'battle', -547, 'Cyrus the Great defeated King Croesus of Lydia at Thymbra and shortly afterwards captured Sardis, bringing Lydia and the Ionian Greek cities under Persian rule.'),
('battle-of-marathon', 'Battle of Marathon', 'battle', -490, 'An Athenian and Plataean force under Miltiades defeated the first Persian invasion force sent by Darius I. Marked the end of Dariuss European campaign and opened the Greco-Persian wars in earnest.'),
('battle-of-gaugamela', 'Battle of Gaugamela', 'battle', -331, 'Alexander the Great decisively defeated Darius III on the plain of Gaugamela in northern Mesopotamia. Ended the Achaemenid Empire as a fighting force.');

INSERT INTO rulers_events (ruler_id, event_id, role) VALUES
((SELECT id FROM rulers WHERE slug='cyrus-the-great'), (SELECT id FROM events WHERE slug='battle-of-thymbra'),   'victor'),
((SELECT id FROM rulers WHERE slug='darius-i'),        (SELECT id FROM events WHERE slug='battle-of-marathon'),  'defeated'),
((SELECT id FROM rulers WHERE slug='darius-iii'),      (SELECT id FROM events WHERE slug='battle-of-gaugamela'), 'defeated'),
-- Cross-civilisation link: Cyrus was the victor at the existing Fall of Babylon event from the Mesopotamia seed.
((SELECT id FROM rulers WHERE slug='cyrus-the-great'), (SELECT id FROM events WHERE slug='fall-of-babylon'),     'victor');

COMMIT;
