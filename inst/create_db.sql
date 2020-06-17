CREATE TABLE tags (
  DateTagged TEXT,
  TagID REAL NOT NULL,
  TagSN REAL NOT NULL,
  CodeSpace REAL,
  Species TEXT,
  Sp TEXT,
  TL REAL,
  FL REAL,
  Sex TEXT,
  TagLoc TEXT,
  TagGroup TEXT,
  Comments TEXT,
  FishID REAL,
  PRIMARY KEY(TagID, TagSN, FishID));

CREATE TABLE detections (
  TagID INTEGER NOT NULL,
  DateTimePST TEXT NOT NULL,
  Receiver INTEGER NOT NULL,
  DateTimeUTC TEXT NOT NULL,
  CodeSpace INTEGER,
  PRIMARY KEY(TagID, DateTimePST, Receiver, CodeSpace)
);

CREATE TABLE deployments (
  Location TEXT,
  StationAbbOld TEXT,
  Station TEXT,
  Receiver INTEGER,
  DetectionYear INTEGER,
  DeploymentStart TEXT,
  DeploymentEnd TEXT,
  VRLDate TEXT,
  DeploymentNotes TEXT,
  VRLNotes TEXT,
  PRIMARY KEY(Location, Station, Receiver, DetectionYear)
);

CREATE TABLE chn (
  DateTagged TEXT,
  TagLoc TEXT,
  TagID INTEGER,
  TagSN INTEGER,
  CodeSpace INTEGER,
  Floy TEXT,
  GeneticAssignment TEXT,
  TOC TEXT,
  FL INTEGER,
  TL INTEGER,
  CO2 NUMERIC,
  SurgStart TEXT,
  SurgEnd TEXT,
  Recov NUMERIC,
  Adipose TEXT,
  Sex TEXT,
  TOR TEXT,
  Bleeding NUMERIC,
  Comments TEXT,
  Surgeon TEXT,
  RecovDO NUMERIC,
  RecovTemp NUMERIC,
  TDTemp NUMERIC,
  TDDO NUMERIC,
  TailGrab NUMERIC,
  BodyFlex NUMERIC,
  HeadComplex NUMERIC,
  VOR NUMERIC,
  Orientation NUMERIC,
  Tide TEXT,
  PRIMARY KEY(TagID, TagSN)
);