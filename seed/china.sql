-- ancient-dynasties-api - China seed data
-- Hand-curated starting corpus. Years are integers, BCE as negative, CE as positive.
-- Shang and early Zhou dates follow the conventional chronology published by the
-- Xia-Shang-Zhou Chronology Project; they remain approximate.
--
-- Dynasties included:
--   * Shang (c. 1600 - 1046 BCE) - earliest archaeologically confirmed dynasty
--   * Western Zhou (1046 - 771 BCE) - founder Wu and the Mandate of Heaven
--   * Qin (221 - 206 BCE) - the first unified empire
--   * Western Han (202 BCE - 9 CE) - Liu Bang and Emperor Wu

BEGIN;

-- ---------------------------------------------------------------------------
-- CIVILIZATION
-- ---------------------------------------------------------------------------
INSERT INTO civilizations (slug, name, region, era_start_year, era_end_year, description) VALUES
('china', 'Ancient China', 'Yellow and Yangtze river valleys, later all of modern China', -1600, 220,
 'From the Bronze Age Shang through the Han, early Chinese civilisation produced oracle-bone writing, large-scale metallurgy, the first unified empire under Qin, and the long Han dynasty that gave the Han ethnonym. This seed covers the early formative dynasties.');

-- ---------------------------------------------------------------------------
-- DYNASTIES
-- ---------------------------------------------------------------------------
INSERT INTO dynasties (civilization_id, slug, name, founder_name, start_year, end_year, description) VALUES
((SELECT id FROM civilizations WHERE slug='china'), 'shang', 'Shang Dynasty', 'Cheng Tang', -1600, -1046,
 'The earliest Chinese dynasty confirmed by archaeology and written record. Known for oracle-bone inscriptions, elite bronze ritual vessels, and a theocratic kingship centred on ancestor worship. Overthrown by the Zhou at the Battle of Muye.'),
((SELECT id FROM civilizations WHERE slug='china'), 'western-zhou', 'Western Zhou Dynasty', 'King Wu of Zhou', -1046, -771,
 'Founded when King Wu defeated the last Shang king. Introduced the Mandate of Heaven as a theory of legitimate rule, a concept that would frame every dynasty afterwards. Collapsed in 771 BCE when nomadic raiders sacked Haojing.'),
((SELECT id FROM civilizations WHERE slug='china'), 'qin', 'Qin Dynasty', 'Qin Shi Huang', -221, -206,
 'Founded by Ying Zheng who adopted the title Huangdi (First Emperor) after conquering the six rival Warring States. Standardised weights, measures, script and the axle widths of carts. Collapsed within four years of its founders death.'),
((SELECT id FROM civilizations WHERE slug='china'), 'western-han', 'Western Han Dynasty', 'Emperor Gaozu (Liu Bang)', -202, 9,
 'Founded by Liu Bang, a commoner who defeated Xiang Yu in the Chu-Han contention. Consolidated the Qin unification and ruled for two centuries. Interrupted in 9 CE by Wang Mang before the Eastern Han restoration.');

-- ---------------------------------------------------------------------------
-- RULERS
-- ---------------------------------------------------------------------------

-- Shang
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='shang'), 'cheng-tang', 'Cheng Tang', '成湯', -1600, -1588, TRUE,
 'Founding king of the Shang. Known traditionally as Tang the Successful. Defeated the last Xia king Jie at the Battle of Mingtiao and established the Shang state. Later venerated as a model of a just founder.'),
((SELECT id FROM dynasties WHERE slug='shang'), 'wu-ding', 'Wu Ding', '武丁', -1250, -1192, TRUE,
 'Twenty-first Shang king and the most powerful. His 58-year reign is richly documented in oracle-bone inscriptions. Led military campaigns against surrounding peoples and was supported by his consort Fu Hao, Chinas first attested female general.'),
((SELECT id FROM dynasties WHERE slug='shang'), 'di-xin', 'Di Xin', '帝辛', -1075, -1046, TRUE,
 'Last king of the Shang, also known as King Zhou of Shang. Traditionally depicted as cruel and extravagant. Defeated by King Wu of Zhou at the Battle of Muye in 1046 BCE and died in the fire of his own palace.');

-- Western Zhou
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='western-zhou'), 'king-wen-of-zhou', 'King Wen of Zhou', '周文王', -1099, -1050, TRUE,
 'Posthumously named founder-figure of the Zhou house. Did not reign as king of the Zhou dynasty proper but laid the political and moral foundation for his son Wu to overthrow the Shang. Credited with contributions to the I Ching.'),
((SELECT id FROM dynasties WHERE slug='western-zhou'), 'king-wu-of-zhou', 'King Wu of Zhou', '周武王', -1046, -1043, FALSE,
 'Founding king of the Western Zhou. Defeated the last Shang king at the Battle of Muye in 1046 BCE and proclaimed the Mandate of Heaven as the basis of his rule. Died only a few years after the conquest.'),
((SELECT id FROM dynasties WHERE slug='western-zhou'), 'king-cheng-of-zhou', 'King Cheng of Zhou', '周成王', -1042, -1021, FALSE,
 'Second king of the Western Zhou and son of King Wu. Came to the throne as a child under the regency of his uncle, the Duke of Zhou. Consolidated the new states authority over the former Shang heartland.');

-- Qin
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='qin'), 'qin-shi-huang', 'Qin Shi Huang', '秦始皇', -221, -210, FALSE,
 'First emperor of a unified China. Conquered the other six Warring States by 221 BCE and took the title Huangdi. Standardised currency, weights, measures and script. Built early sections of the Great Wall and the Terracotta Army tomb complex at Xianyang.'),
((SELECT id FROM dynasties WHERE slug='qin'), 'qin-er-shi', 'Qin Er Shi', '秦二世', -210, -207, FALSE,
 'Second and last emperor of the Qin. Son of Qin Shi Huang. Took the throne through a succession plot by the chancellor Li Si and the eunuch Zhao Gao. His short reign ended in rebellion and his forced suicide.');

-- Western Han
INSERT INTO rulers (dynasty_id, slug, name, name_native, reign_start, reign_end, is_approximate, description) VALUES
((SELECT id FROM dynasties WHERE slug='western-han'), 'emperor-gaozu-of-han', 'Emperor Gaozu of Han', '漢高祖 (劉邦)', -202, -195, FALSE,
 'Founder of the Han dynasty, born Liu Bang. A commoner of peasant origin who rose during the uprisings against Qin. Defeated his rival Xiang Yu at the Battle of Gaixia in 202 BCE and reunified China under a lighter-touch Confucian-influenced rule.'),
((SELECT id FROM dynasties WHERE slug='western-han'), 'emperor-wu-of-han', 'Emperor Wu of Han', '漢武帝', -141, -87, FALSE,
 'Seventh Han emperor and one of Chinas longest-reigning. Expanded the empire into Central Asia, Korea and Vietnam, made Confucianism state orthodoxy, opened the Silk Road to the west and created the imperial examination system in embryonic form.');

-- ---------------------------------------------------------------------------
-- SECOND PASS: predecessor / successor / father wiring
-- ---------------------------------------------------------------------------

-- Western Zhou: a clean three-generation father-son chain (Wen is honorary; Wu is the ruling founder).
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='king-wen-of-zhou'),
                  successor_id = (SELECT id FROM rulers WHERE slug='king-cheng-of-zhou') WHERE slug='king-wu-of-zhou';
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='king-wu-of-zhou'),
                  predecessor_id = (SELECT id FROM rulers WHERE slug='king-wu-of-zhou') WHERE slug='king-cheng-of-zhou';

-- Qin: Qin Er Shi was the son of Qin Shi Huang.
UPDATE rulers SET successor_id = (SELECT id FROM rulers WHERE slug='qin-er-shi') WHERE slug='qin-shi-huang';
UPDATE rulers SET father_id = (SELECT id FROM rulers WHERE slug='qin-shi-huang'),
                  predecessor_id = (SELECT id FROM rulers WHERE slug='qin-shi-huang') WHERE slug='qin-er-shi';

-- Shang: skipping intra-dynasty links because we only sampled 3 of ~30 kings. Leaving fields null is honest.
-- Western Han: likewise skipping Gaozu → Emperor Wu (6 emperors between them).

-- ---------------------------------------------------------------------------
-- PLACES
-- ---------------------------------------------------------------------------
INSERT INTO places (slug, name, modern_name, latitude, longitude, era_start_year, era_end_year, description) VALUES
('yin-anyang', 'Yin', 'Anyang, Henan', 36.12778, 114.31167, -1300, -1046, 'The last capital of the Shang dynasty, excavated at Yinxu near modern Anyang. Produced over 150,000 oracle-bone fragments and the royal tombs of the late Shang kings.'),
('haojing', 'Haojing', 'near Xi''an, Shaanxi', 34.21667, 108.78333, -1046, -771, 'The capital of the Western Zhou, on the banks of the Feng River near modern Xi''an. Sacked by Quanrong raiders in 771 BCE, which triggered the Zhou capitals eastward move.'),
('xianyang', 'Xianyang', 'Xianyang, Shaanxi', 34.32917, 108.70889, -221, -206, 'The Qin capital built across the Wei River from modern Xi''an. Site of Qin Shi Huangs palace complex and starting point of the roads system that radiated across the newly unified empire.'),
('changan-han', 'Chang''an', 'Xi''an, Shaanxi', 34.26611, 108.94417, -202, 9, 'The capital of the Western Han, established by Liu Bang south-east of the former Qin capital. One of the largest cities in the ancient world, and the eastern terminus of the Silk Road.');

INSERT INTO rulers_places (ruler_id, place_id, context) VALUES
((SELECT id FROM rulers WHERE slug='wu-ding'),              (SELECT id FROM places WHERE slug='yin-anyang'),   'capital'),
((SELECT id FROM rulers WHERE slug='di-xin'),               (SELECT id FROM places WHERE slug='yin-anyang'),   'capital'),
((SELECT id FROM rulers WHERE slug='king-wu-of-zhou'),      (SELECT id FROM places WHERE slug='haojing'),      'capital'),
((SELECT id FROM rulers WHERE slug='king-cheng-of-zhou'),   (SELECT id FROM places WHERE slug='haojing'),      'capital'),
((SELECT id FROM rulers WHERE slug='qin-shi-huang'),        (SELECT id FROM places WHERE slug='xianyang'),     'capital'),
((SELECT id FROM rulers WHERE slug='qin-er-shi'),           (SELECT id FROM places WHERE slug='xianyang'),     'capital'),
((SELECT id FROM rulers WHERE slug='emperor-gaozu-of-han'), (SELECT id FROM places WHERE slug='changan-han'),  'capital'),
((SELECT id FROM rulers WHERE slug='emperor-wu-of-han'),    (SELECT id FROM places WHERE slug='changan-han'),  'capital');

-- ---------------------------------------------------------------------------
-- EVENTS
-- ---------------------------------------------------------------------------
INSERT INTO events (slug, name, event_type, year, description) VALUES
('battle-of-muye', 'Battle of Muye', 'battle', -1046, 'Decisive battle in which King Wu of Zhou defeated the Shang forces of Di Xin. Marked the end of the Shang dynasty and the start of the Zhou, and later became the founding event invoked under the Mandate of Heaven theory.'),
('unification-of-china', 'Unification of China under Qin', 'founding', -221, 'Ying Zheng of Qin completed the conquest of the six rival Warring States and declared himself Qin Shi Huang, First Emperor. Established the first centralised empire in East Asian history.'),
('battle-of-gaixia', 'Battle of Gaixia', 'battle', -202, 'The final battle of the Chu-Han contention. Liu Bang of Han defeated Xiang Yu of Chu, who then took his own life. Liu Bang was proclaimed emperor and founded the Han dynasty shortly afterwards.');

INSERT INTO rulers_events (ruler_id, event_id, role) VALUES
((SELECT id FROM rulers WHERE slug='king-wu-of-zhou'),      (SELECT id FROM events WHERE slug='battle-of-muye'),       'victor'),
((SELECT id FROM rulers WHERE slug='di-xin'),               (SELECT id FROM events WHERE slug='battle-of-muye'),       'defeated'),
((SELECT id FROM rulers WHERE slug='qin-shi-huang'),        (SELECT id FROM events WHERE slug='unification-of-china'), 'founder'),
((SELECT id FROM rulers WHERE slug='emperor-gaozu-of-han'), (SELECT id FROM events WHERE slug='battle-of-gaixia'),     'victor');

COMMIT;
