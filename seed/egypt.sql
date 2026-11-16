-- ancient-dynasties-api - Egypt seed data
-- Hand-curated starting corpus. Years are integers, BCE as negative.
-- Reign dates for 3rd millennium BCE are approximate (conventional chronology).
--
-- Dynasties included:
--   * Old Kingdom - 4th Dynasty (c.2613 - c.2494 BCE)
--   * New Kingdom - 18th Dynasty (c.1550 - c.1292 BCE)
--   * New Kingdom - 19th Dynasty (c.1292 - c.1189 BCE)
--   * Ptolemaic Kingdom (305 - 30 BCE)

BEGIN;

-- ---------------------------------------------------------------------------
-- CIVILIZATION
-- ---------------------------------------------------------------------------
INSERT INTO civilizations (slug, name, region, era_start_year, era_end_year, description) VALUES
('egypt', 'Ancient Egypt', 'Nile Valley (modern Egypt and northern Sudan)', -3100, -30,
 'The civilisation of the Nile Valley, from the First Dynasty around 3100 BCE until the Roman annexation in 30 BCE. Divided conventionally into Old, Middle and New Kingdoms with intermediate periods of fragmentation.');

-- ---------------------------------------------------------------------------
-- DYNASTIES
-- ---------------------------------------------------------------------------
INSERT INTO dynasties (civilization_id, slug, name, founder_name, start_year, end_year, description) VALUES
((SELECT id FROM civilizations WHERE slug='egypt'), 'egypt-4th-dynasty', 'Old Kingdom 4th Dynasty', 'Sneferu', -2613, -2494,
 'The pyramid-building dynasty. Sneferu, Khufu, Khafre and Menkaure built the Red Pyramid and the three Great Pyramids of Giza. Marked the peak of the Old Kingdom.'),
((SELECT id FROM civilizations WHERE slug='egypt'), 'egypt-18th-dynasty', 'New Kingdom 18th Dynasty', 'Ahmose I', -1550, -1292,
 'The dynasty of the Egyptian Empire at its height. Expelled the Hyksos, expanded into Nubia and the Levant, produced Hatshepsut, Thutmose III, Akhenaten and Tutankhamun.'),
((SELECT id FROM civilizations WHERE slug='egypt'), 'egypt-19th-dynasty', 'New Kingdom 19th Dynasty', 'Ramesses I', -1292, -1189,
 'The Ramesside line. Peaked under Ramesses II, who ruled for 66 years and fought the Hittites to a stalemate at Kadesh before signing the earliest surviving peace treaty.'),
((SELECT id FROM civilizations WHERE slug='egypt'), 'ptolemaic', 'Ptolemaic Kingdom', 'Ptolemy I Soter', -305, -30,
 'Greek dynasty founded by one of Alexander the Greats generals after his death. Ruled Egypt from Alexandria, spoke Greek, adopted Pharaonic customs. Ended with Cleopatra VII and the Roman annexation.');

-- ---------------------------------------------------------------------------
-- RULERS
-- Inserted in reign order per dynasty.
-- ---------------------------------------------------------------------------

-- Old Kingdom 4th Dynasty
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='egypt-4th-dynasty'), 'sneferu', 'Sneferu', 'Snfrw', -2613, -2589, TRUE,
 'Founder of the 4th Dynasty. Built the Bent Pyramid and the Red Pyramid at Dahshur, refining the geometry that his son Khufu would perfect at Giza.'),
((SELECT id FROM dynasties WHERE slug='egypt-4th-dynasty'), 'khufu', 'Khufu', 'Ḫwfw', -2589, -2566, TRUE,
 'Son of Sneferu. Commissioned the Great Pyramid of Giza, the largest of the three Giza pyramids and one of the Seven Wonders of the Ancient World.'),
((SELECT id FROM dynasties WHERE slug='egypt-4th-dynasty'), 'khafre', 'Khafre', 'Ḫ3f-Rˁ', -2558, -2532, TRUE,
 'Son of Khufu. Built the second of the Giza pyramids and almost certainly commissioned the Great Sphinx. His pyramid complex is the best preserved of the three.'),
((SELECT id FROM dynasties WHERE slug='egypt-4th-dynasty'), 'menkaure', 'Menkaure', 'Mn-k3w-Rˁ', -2532, -2503, TRUE,
 'Son of Khafre. Built the smallest of the three Giza pyramids but commissioned exceptional statuary. His reign marked the beginning of the decline in Old Kingdom pyramid scale.');

-- New Kingdom 18th Dynasty
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='egypt-18th-dynasty'), 'ahmose-i', 'Ahmose I', 'Iˁḥ-ms', -1550, -1525, TRUE,
 'Founder of the 18th Dynasty and the New Kingdom. Expelled the Hyksos from the Nile Delta and reunified Egypt after two centuries of foreign rule.'),
((SELECT id FROM dynasties WHERE slug='egypt-18th-dynasty'), 'hatshepsut', 'Hatshepsut', 'Ḥ3t-špswt', -1479, -1458, TRUE,
 'One of the few female pharaohs. Ruled as regent for her stepson Thutmose III then as pharaoh in her own right. Known for her mortuary temple at Deir el-Bahari and her expedition to the land of Punt.'),
((SELECT id FROM dynasties WHERE slug='egypt-18th-dynasty'), 'thutmose-iii', 'Thutmose III', 'Ḏḥwtj-ms', -1479, -1425, TRUE,
 'Stepson of Hatshepsut. After her death, led seventeen military campaigns into the Levant and Syria, extending Egyptian influence to its greatest geographic reach. Often called the Napoleon of Egypt.'),
((SELECT id FROM dynasties WHERE slug='egypt-18th-dynasty'), 'akhenaten', 'Akhenaten', '3ḫ-n-Itn', -1353, -1336, TRUE,
 'Religious revolutionary. Abandoned the traditional polytheistic pantheon in favour of the sun disc Aten, moved the capital to Amarna, and reshaped Egyptian art. His reforms were almost entirely reversed after his death.'),
((SELECT id FROM dynasties WHERE slug='egypt-18th-dynasty'), 'tutankhamun', 'Tutankhamun', 'Twt-ˁnḫ-Imn', -1332, -1323, TRUE,
 'Son of Akhenaten. Restored the traditional religion and moved the capital back to Memphis. Died young. His intact tomb, discovered in 1922, is the archaeological find of the 20th century.');

-- New Kingdom 19th Dynasty
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='egypt-19th-dynasty'), 'ramesses-i', 'Ramesses I', 'Rˁ-ms-sw', -1292, -1290, FALSE,
 'Founder of the 19th Dynasty. Elderly military officer chosen as heir by the childless Horemheb. Reigned less than two years but established the Ramesside line.'),
((SELECT id FROM dynasties WHERE slug='egypt-19th-dynasty'), 'seti-i', 'Seti I', 'Stẖj', -1290, -1279, FALSE,
 'Son of Ramesses I. Restored Egyptian authority in the Levant, campaigned against the Hittites, and built the great hypostyle hall at Karnak.'),
((SELECT id FROM dynasties WHERE slug='egypt-19th-dynasty'), 'ramesses-ii', 'Ramesses II', 'Rˁ-ms-sw', -1279, -1213, FALSE,
 'Greatest of the Ramesside pharaohs. Reigned for 66 years. Fought the Hittites at Kadesh in 1274 BCE, signed the first known international peace treaty, and left monuments across Egypt including Abu Simbel.');

-- Ptolemaic Kingdom
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='ptolemaic'), 'ptolemy-i-soter', 'Ptolemy I Soter', 'Ptolemaios Sōtēr', -305, -282, FALSE,
 'Founder of the Ptolemaic Kingdom. One of Alexander the Greats trusted generals. Seized Egypt after Alexanders death and founded the Library of Alexandria and the Pharos lighthouse.'),
((SELECT id FROM dynasties WHERE slug='ptolemaic'), 'ptolemy-ii-philadelphus', 'Ptolemy II Philadelphus', 'Ptolemaios Philadelphos', -282, -246, FALSE,
 'Son of Ptolemy I. Extended the Library and the Museum of Alexandria, commissioned the Septuagint translation of the Hebrew Bible into Greek, and completed the Pharos lighthouse.'),
((SELECT id FROM dynasties WHERE slug='ptolemaic'), 'cleopatra-vii', 'Cleopatra VII', 'Kleopatra', -51, -30, FALSE,
 'Last active ruler of Ptolemaic Egypt. Fluent in Egyptian (uniquely for her dynasty) and politically allied with Julius Caesar then Mark Antony. Died by suicide after defeat at Actium; Egypt became a Roman province.');

-- ---------------------------------------------------------------------------
-- SECOND PASS: wire up predecessor / successor / father references
-- ---------------------------------------------------------------------------

-- 4th Dynasty line: Sneferu -> Khufu -> Khafre -> Menkaure (father-son throughout)
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='khufu') WHERE slug='sneferu';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='sneferu'),
                  father_id = (SELECT id FROM rulers WHERE slug='sneferu'),
                  successor_id = (SELECT id FROM rulers WHERE slug='khafre') WHERE slug='khufu';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='khufu'),
                  father_id = (SELECT id FROM rulers WHERE slug='khufu'),
                  successor_id = (SELECT id FROM rulers WHERE slug='menkaure') WHERE slug='khafre';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='khafre'),
                  father_id = (SELECT id FROM rulers WHERE slug='khafre') WHERE slug='menkaure';

-- 18th Dynasty: Akhenaten is father of Tutankhamun (DNA-confirmed in 2010)
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='akhenaten') WHERE slug='tutankhamun';

-- 19th Dynasty line: Ramesses I -> Seti I -> Ramesses II (father-son throughout)
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='seti-i') WHERE slug='ramesses-i';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='ramesses-i'),
                  father_id = (SELECT id FROM rulers WHERE slug='ramesses-i'),
                  successor_id = (SELECT id FROM rulers WHERE slug='ramesses-ii') WHERE slug='seti-i';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='seti-i'),
                  father_id = (SELECT id FROM rulers WHERE slug='seti-i') WHERE slug='ramesses-ii';

-- Ptolemaic: Ptolemy I -> Ptolemy II (father-son)
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='ptolemy-ii-philadelphus') WHERE slug='ptolemy-i-soter';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='ptolemy-i-soter'),
                  father_id = (SELECT id FROM rulers WHERE slug='ptolemy-i-soter') WHERE slug='ptolemy-ii-philadelphus';

-- ---------------------------------------------------------------------------
-- PLACES
-- ---------------------------------------------------------------------------
INSERT INTO places (slug, name, modern_name, latitude, longitude, era_start_year, era_end_year, description) VALUES
('memphis-egypt', 'Memphis', 'Mit Rahina', 29.84500, 31.25000, -3100, -300, 'First capital of a unified Egypt. Administrative and religious centre throughout the Old Kingdom.'),
('giza', 'Giza', 'Giza', 29.97917, 31.13417, -2600, -2500, 'The pyramid complex of the 4th Dynasty on the west bank of the Nile. Site of the three Great Pyramids and the Sphinx.'),
('thebes-egypt', 'Thebes', 'Luxor', 25.68722, 32.63944, -2000, -1000, 'Religious and political capital of the New Kingdom. Site of Karnak and Luxor temples, with royal tombs in the Valley of the Kings opposite.'),
('amarna', 'Akhetaten', 'Amarna', 27.64167, 30.90000, -1353, -1332, 'Capital founded by Akhenaten as the centre of his new sun-disc religion. Abandoned after his death and the restoration of the traditional cults.'),
('alexandria', 'Alexandria', 'Alexandria', 31.20000, 29.91667, -331, 641, 'Hellenistic city founded by Alexander the Great in 331 BCE. Capital of the Ptolemaic Kingdom and home to the Library of Alexandria and the Pharos lighthouse.');

INSERT INTO rulers_places (ruler_id, place_id, context) VALUES
((SELECT id FROM rulers WHERE slug='khufu'),             (SELECT id FROM places WHERE slug='giza'),       'pyramid site'),
((SELECT id FROM rulers WHERE slug='khafre'),            (SELECT id FROM places WHERE slug='giza'),       'pyramid site'),
((SELECT id FROM rulers WHERE slug='menkaure'),          (SELECT id FROM places WHERE slug='giza'),       'pyramid site'),
((SELECT id FROM rulers WHERE slug='akhenaten'),         (SELECT id FROM places WHERE slug='amarna'),     'capital'),
((SELECT id FROM rulers WHERE slug='tutankhamun'),       (SELECT id FROM places WHERE slug='memphis-egypt'), 'capital'),
((SELECT id FROM rulers WHERE slug='hatshepsut'),        (SELECT id FROM places WHERE slug='thebes-egypt'), 'capital'),
((SELECT id FROM rulers WHERE slug='ramesses-ii'),       (SELECT id FROM places WHERE slug='thebes-egypt'), 'capital'),
((SELECT id FROM rulers WHERE slug='ptolemy-i-soter'),   (SELECT id FROM places WHERE slug='alexandria'), 'capital'),
((SELECT id FROM rulers WHERE slug='ptolemy-ii-philadelphus'), (SELECT id FROM places WHERE slug='alexandria'), 'capital'),
((SELECT id FROM rulers WHERE slug='cleopatra-vii'),     (SELECT id FROM places WHERE slug='alexandria'), 'capital');

-- ---------------------------------------------------------------------------
-- EVENTS
-- ---------------------------------------------------------------------------
INSERT INTO events (slug, name, event_type, year, description) VALUES
('battle-of-kadesh', 'Battle of Kadesh', 'battle', -1274,
 'Ramesses II fought Muwatalli II of the Hittite Empire to a tactical draw near the Orontes River. Followed sixteen years later by the earliest surviving international peace treaty.'),
('egyptian-hittite-peace-treaty', 'Egyptian-Hittite Peace Treaty', 'treaty', -1258,
 'Peace treaty between Ramesses II of Egypt and Hattusili III of the Hittites. The earliest surviving international peace treaty. A copy hangs at the United Nations in New York.'),
('founding-of-alexandria', 'Founding of Alexandria', 'founding', -331,
 'Alexander the Great founded the city of Alexandria on the Mediterranean coast during his conquest of the Persian Empire. It became the Hellenistic worlds leading centre of learning.'),
('battle-of-actium', 'Battle of Actium', 'battle', -31,
 'Octavian defeated the combined fleet of Mark Antony and Cleopatra VII off the coast of western Greece. Ended the Ptolemaic Kingdoms independence within a year.'),
('death-of-cleopatra', 'Death of Cleopatra VII', 'death', -30,
 'Cleopatra VII died by suicide in Alexandria after Octavian entered the city. Egypt became a Roman province under direct imperial control.');

INSERT INTO rulers_events (ruler_id, event_id, role) VALUES
((SELECT id FROM rulers WHERE slug='ramesses-ii'),   (SELECT id FROM events WHERE slug='battle-of-kadesh'),                 'participant'),
((SELECT id FROM rulers WHERE slug='ramesses-ii'),   (SELECT id FROM events WHERE slug='egyptian-hittite-peace-treaty'),    'signatory'),
((SELECT id FROM rulers WHERE slug='ptolemy-i-soter'), (SELECT id FROM events WHERE slug='founding-of-alexandria'),           'participant'),
((SELECT id FROM rulers WHERE slug='cleopatra-vii'),  (SELECT id FROM events WHERE slug='battle-of-actium'),                 'defeated'),
((SELECT id FROM rulers WHERE slug='cleopatra-vii'),  (SELECT id FROM events WHERE slug='death-of-cleopatra'),               'subject');

COMMIT;
