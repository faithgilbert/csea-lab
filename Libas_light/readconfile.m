% readconfile%liest bedingungsvector aus con-file %function [condmat] = readconfile(ConFilePath);if nargin < 1	[file, path] = uigetfile('*.con', 'open confile')	ConFilePath = [path file]end[condmat] = ReadData(ConFilePath,1,[],'ascii','ascii');