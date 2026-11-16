-- ancient-dynasties-api - Rome seed data
-- Hand-curated starting corpus. Years are integers, BCE as negative, CE as positive.
-- Early kingdom reign dates are legendary / semi-legendary.
--
-- Dynasties included:
--   * Roman Kingdom (753 - 509 BCE) - the seven legendary kings
--   * Julio-Claudian Dynasty (27 BCE - 68 CE) - first three emperors shown
--
-- The Republic (509 - 27 BCE) had no dynasty so is intentionally skipped.

BEGIN;

-- ---------------------------------------------------------------------------
-- CIVILIZATION
-- ---------------------------------------------------------------------------
INSERT INTO civilizations (slug, name, region, era_start_year, era_end_year, description) VALUES
('rome', 'Ancient Rome', 'Italian peninsula, later the whole Mediterranean basin', -753, 476,
 'Founded by legend in 753 BCE, Rome grew through a monarchy, a republic, and a vast empire until the fall of the Western Empire in 476 CE. This seed covers the Kingdom and the start of the Principate.');

-- ---------------------------------------------------------------------------
-- DYNASTIES
-- ---------------------------------------------------------------------------
INSERT INTO dynasties (civilization_id, slug, name, founder_name, start_year, end_year, description) VALUES
((SELECT id FROM civilizations WHERE slug='rome'), 'roman-kingdom', 'Roman Kingdom', 'Romulus', -753, -509,
 'The seven legendary kings of Rome, from Romulus to Tarquin the Proud. Most details are preserved in later Roman historians and mix history with myth. Ended with the expulsion of Tarquin and the founding of the Republic.'),
((SELECT id FROM civilizations WHERE slug='rome'), 'julio-claudian', 'Julio-Claudian Dynasty', 'Augustus', -27, 68,
 'The first imperial dynasty of Rome. Founded by Augustus after the civil wars of the late Republic, descended from the Julian and Claudian lines. Ended with the suicide of Nero.');

-- ---------------------------------------------------------------------------
-- RULERS
-- ---------------------------------------------------------------------------

-- Roman Kingdom - the seven legendary kings
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'romulus', 'Romulus', 'Romulus', -753, -716, TRUE,
 'Legendary founder of Rome and its first king. Son of Mars and Rhea Silvia, raised with his twin Remus by a she-wolf. Named the city after himself and established its earliest institutions.'),
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'numa-pompilius', 'Numa Pompilius', 'Numa Pompilius', -715, -673, TRUE,
 'Second king of Rome. A Sabine chosen for his wisdom. Credited with establishing most of Romes major religious institutions including the Vestal Virgins and the calendar reform.'),
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'tullus-hostilius', 'Tullus Hostilius', 'Tullus Hostilius', -673, -642, TRUE,
 'Third king of Rome. A warrior king who destroyed the rival city of Alba Longa and expanded Roman territory. Died of lightning, which the Romans interpreted as punishment for religious neglect.'),
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'ancus-marcius', 'Ancus Marcius', 'Ancus Marcius', -642, -617, TRUE,
 'Fourth king of Rome. Grandson of Numa Pompilius. Built the first bridge over the Tiber, founded the port of Ostia, and conquered several neighbouring Latin towns.'),
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'tarquinius-priscus', 'Tarquinius Priscus', 'L. Tarquinius Priscus', -616, -579, TRUE,
 'Fifth king of Rome and the first of the Etruscan dynasty. Expanded the Senate, built the Circus Maximus, and began the Temple of Jupiter on the Capitoline Hill.'),
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'servius-tullius', 'Servius Tullius', 'Servius Tullius', -578, -535, TRUE,
 'Sixth king of Rome. Of servile origin by legend. Conducted the first census, reorganised the army by wealth-based classes, and built the Servian Wall around the city.'),
((SELECT id FROM dynasties WHERE slug='roman-kingdom'), 'tarquinius-superbus', 'Tarquinius Superbus', 'L. Tarquinius Superbus', -534, -509, TRUE,
 'Seventh and last king of Rome. Remembered as a tyrant. His sons rape of Lucretia triggered a revolt led by Lucius Junius Brutus, ending the monarchy and founding the Republic.');

-- Julio-Claudian Dynasty - first three emperors
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='julio-claudian'), 'augustus', 'Augustus', 'Imperator Caesar Divi filius Augustus', -27, 14, FALSE,
 'First Roman emperor. Great-nephew and adopted heir of Julius Caesar. Won the civil wars following Caesars assassination, reformed the state as the Principate, and ruled for 41 years. Died at Nola in 14 CE.'),
((SELECT id FROM dynasties WHERE slug='julio-claudian'), 'tiberius', 'Tiberius', 'Tiberius Caesar Augustus', 14, 37, FALSE,
 'Second Roman emperor. Stepson of Augustus and seasoned military commander. Reign marked by capable administration followed by withdrawal to Capri and a dark final decade of treason trials.'),
((SELECT id FROM dynasties WHERE slug='julio-claudian'), 'caligula', 'Caligula', 'Gaius Caesar Augustus Germanicus', 37, 41, FALSE,
 'Third Roman emperor. Grand-nephew of Tiberius, son of the popular general Germanicus. Initial good reign deteriorated into instability and alleged cruelty. Assassinated by the Praetorian Guard after less than four years.');

-- ---------------------------------------------------------------------------
-- SECOND PASS: predecessor / successor wiring
-- ---------------------------------------------------------------------------

-- Roman Kingdom succession (not father-son: Roman kings were often elected rather than inherited)
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='numa-pompilius') WHERE slug='romulus';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='romulus'),
                  successor_id = (SELECT id FROM rulers WHERE slug='tullus-hostilius') WHERE slug='numa-pompilius';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='numa-pompilius'),
                  successor_id = (SELECT id FROM rulers WHERE slug='ancus-marcius') WHERE slug='tullus-hostilius';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='tullus-hostilius'),
                  successor_id = (SELECT id FROM rulers WHERE slug='tarquinius-priscus') WHERE slug='ancus-marcius';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='ancus-marcius'),
                  successor_id = (SELECT id FROM rulers WHERE slug='servius-tullius') WHERE slug='tarquinius-priscus';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='tarquinius-priscus'),
                  successor_id = (SELECT id FROM rulers WHERE slug='tarquinius-superbus') WHERE slug='servius-tullius';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='servius-tullius'),
                  father_id = (SELECT id FROM rulers WHERE slug='tarquinius-priscus') WHERE slug='tarquinius-superbus';

-- Julio-Claudian succession
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='tiberius') WHERE slug='augustus';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='augustus'),
                  successor_id = (SELECT id FROM rulers WHERE slug='caligula') WHERE slug='tiberius';
UPDATE rulers SET predecessor_id = (SELECT id FROM rulers WHERE slug='tiberius') WHERE slug='caligula';
-- (Tiberius was Augustus' stepson, not blood son; Caligula was Tiberius' great-nephew, so no father_id links.)

-- ---------------------------------------------------------------------------
-- PLACES
-- ---------------------------------------------------------------------------
INSERT INTO places (slug, name, modern_name, latitude, longitude, era_start_year, era_end_year, description) VALUES
('rome-city', 'Rome', 'Rome', 41.89028, 12.49222, -753, 476, 'The city on the Tiber. Capital of the Kingdom, the Republic and the Empire through to its fall in 476 CE.'),
('capri', 'Capri', 'Capri', 40.55111, 14.24222, -800, 500, 'Small island off the Bay of Naples. Tiberius famously withdrew here from 26 CE and ruled the empire by messenger for the last decade of his reign.');

INSERT INTO rulers_places (ruler_id, place_id, context) VALUES
((SELECT id FROM rulers WHERE slug='romulus'),              (SELECT id FROM places WHERE slug='rome-city'), 'founder'),
((SELECT id FROM rulers WHERE slug='tarquinius-superbus'),  (SELECT id FROM places WHERE slug='rome-city'), 'capital'),
((SELECT id FROM rulers WHERE slug='augustus'),             (SELECT id FROM places WHERE slug='rome-city'), 'capital'),
((SELECT id FROM rulers WHERE slug='tiberius'),             (SELECT id FROM places WHERE slug='capri'),     'retreat'),
((SELECT id FROM rulers WHERE slug='caligula'),             (SELECT id FROM places WHERE slug='rome-city'), 'capital');

-- ---------------------------------------------------------------------------
-- EVENTS
-- ---------------------------------------------------------------------------
INSERT INTO events (slug, name, event_type, year, description) VALUES
('founding-of-rome', 'Founding of Rome', 'founding', -753, 'Traditional date for the founding of Rome by Romulus. Later adopted as year zero of the Roman calendar (ab urbe condita).'),
('expulsion-of-tarquin', 'Expulsion of Tarquin the Proud', 'uprising', -509, 'Lucius Junius Brutus led a revolt that overthrew Tarquinius Superbus after his sons assault on Lucretia. Marked the end of the Roman monarchy and founding of the Roman Republic.'),
('assassination-of-caligula', 'Assassination of Caligula', 'death', 41, 'Caligula was murdered by officers of the Praetorian Guard inside the imperial palace. His uncle Claudius was proclaimed emperor by the Guard the same day.');

INSERT INTO rulers_events (ruler_id, event_id, role) VALUES
((SELECT id FROM rulers WHERE slug='romulus'),              (SELECT id FROM events WHERE slug='founding-of-rome'),       'founder'),
((SELECT id FROM rulers WHERE slug='tarquinius-superbus'),  (SELECT id FROM events WHERE slug='expulsion-of-tarquin'),   'defeated'),
((SELECT id FROM rulers WHERE slug='caligula'),             (SELECT id FROM events WHERE slug='assassination-of-caligula'), 'subject');

COMMIT;
