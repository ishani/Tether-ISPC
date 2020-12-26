// ---------------------------------------------------------------------------------------------------------------------
// Tether-ISPC by Harry Denholm, ishani.org 2020
// https://github.com/ishani/Tether-ISPC
// ---------------------------------------------------------------------------------------------------------------------
// unrolled FFT code for a 1024-wide window, custom generated from the Q library C++ templated version (see qlib.fft.h)
//

#include "common.isph"

#ifdef TETHER_COMPILE_SERIAL
#define const_expr static constexpr
#define ispc_swap std::swap
#else
#define const_expr const
#define ispc_swap( _a, _b ) { uniform float _tswap = _b; _b = _a; _a = _tswap; }
#endif

// ------------------------------------------------------------------------------------------------
// example of walking data from the FFT and condensing power values for a lower band, for example
// if one were going to compute energy and beat detection for an audio signal
//
export uniform float fft_1024_extract_lowband( 
    uniform float fftDataIn[] )
{
    uniform float fftWindowRcp = 1.0f / 1024.0f;

    float subband0 = 0.0f;

#ifdef TETHER_COMPILE_SERIAL
    for (uniform int i = 0; i < 1024; i ++)
#else
    foreach (i = 0 ... 1024)
#endif
    {
        const int32_t interleavedIndex = i << 1;

        const float outReal = fftDataIn[interleavedIndex];
        const float outImag = fftDataIn[interleavedIndex + 1];

        const float fftPower = (outReal * outReal) + (outImag * outImag);

        const float fftMag = 2.0f * STDN sqrt( fftPower ) * fftWindowRcp;

        // choose band bucket
        const int subbandIdx = i >> 5;
        cif ( subbandIdx == 0 )
            subband0 += fftMag;
    }

    return reduce_add(subband0);
}

// ------------------------------------------------------------------------------------------------

export void fft_1024_unrolled( 
    uniform float data[] )
{
    ispc_swap( data[1024], data[2] );
    ispc_swap( data[1025], data[3] );
    ispc_swap( data[512], data[4] );
    ispc_swap( data[513], data[5] );
    ispc_swap( data[1536], data[6] );
    ispc_swap( data[1537], data[7] );
    ispc_swap( data[256], data[8] );
    ispc_swap( data[257], data[9] );
    ispc_swap( data[1280], data[10] );
    ispc_swap( data[1281], data[11] );
    ispc_swap( data[768], data[12] );
    ispc_swap( data[769], data[13] );
    ispc_swap( data[1792], data[14] );
    ispc_swap( data[1793], data[15] );
    ispc_swap( data[128], data[16] );
    ispc_swap( data[129], data[17] );
    ispc_swap( data[1152], data[18] );
    ispc_swap( data[1153], data[19] );
    ispc_swap( data[640], data[20] );
    ispc_swap( data[641], data[21] );
    ispc_swap( data[1664], data[22] );
    ispc_swap( data[1665], data[23] );
    ispc_swap( data[384], data[24] );
    ispc_swap( data[385], data[25] );
    ispc_swap( data[1408], data[26] );
    ispc_swap( data[1409], data[27] );
    ispc_swap( data[896], data[28] );
    ispc_swap( data[897], data[29] );
    ispc_swap( data[1920], data[30] );
    ispc_swap( data[1921], data[31] );
    ispc_swap( data[64], data[32] );
    ispc_swap( data[65], data[33] );
    ispc_swap( data[1088], data[34] );
    ispc_swap( data[1089], data[35] );
    ispc_swap( data[576], data[36] );
    ispc_swap( data[577], data[37] );
    ispc_swap( data[1600], data[38] );
    ispc_swap( data[1601], data[39] );
    ispc_swap( data[320], data[40] );
    ispc_swap( data[321], data[41] );
    ispc_swap( data[1344], data[42] );
    ispc_swap( data[1345], data[43] );
    ispc_swap( data[832], data[44] );
    ispc_swap( data[833], data[45] );
    ispc_swap( data[1856], data[46] );
    ispc_swap( data[1857], data[47] );
    ispc_swap( data[192], data[48] );
    ispc_swap( data[193], data[49] );
    ispc_swap( data[1216], data[50] );
    ispc_swap( data[1217], data[51] );
    ispc_swap( data[704], data[52] );
    ispc_swap( data[705], data[53] );
    ispc_swap( data[1728], data[54] );
    ispc_swap( data[1729], data[55] );
    ispc_swap( data[448], data[56] );
    ispc_swap( data[449], data[57] );
    ispc_swap( data[1472], data[58] );
    ispc_swap( data[1473], data[59] );
    ispc_swap( data[960], data[60] );
    ispc_swap( data[961], data[61] );
    ispc_swap( data[1984], data[62] );
    ispc_swap( data[1985], data[63] );
    ispc_swap( data[1056], data[66] );
    ispc_swap( data[1057], data[67] );
    ispc_swap( data[544], data[68] );
    ispc_swap( data[545], data[69] );
    ispc_swap( data[1568], data[70] );
    ispc_swap( data[1569], data[71] );
    ispc_swap( data[288], data[72] );
    ispc_swap( data[289], data[73] );
    ispc_swap( data[1312], data[74] );
    ispc_swap( data[1313], data[75] );
    ispc_swap( data[800], data[76] );
    ispc_swap( data[801], data[77] );
    ispc_swap( data[1824], data[78] );
    ispc_swap( data[1825], data[79] );
    ispc_swap( data[160], data[80] );
    ispc_swap( data[161], data[81] );
    ispc_swap( data[1184], data[82] );
    ispc_swap( data[1185], data[83] );
    ispc_swap( data[672], data[84] );
    ispc_swap( data[673], data[85] );
    ispc_swap( data[1696], data[86] );
    ispc_swap( data[1697], data[87] );
    ispc_swap( data[416], data[88] );
    ispc_swap( data[417], data[89] );
    ispc_swap( data[1440], data[90] );
    ispc_swap( data[1441], data[91] );
    ispc_swap( data[928], data[92] );
    ispc_swap( data[929], data[93] );
    ispc_swap( data[1952], data[94] );
    ispc_swap( data[1953], data[95] );
    ispc_swap( data[1120], data[98] );
    ispc_swap( data[1121], data[99] );
    ispc_swap( data[608], data[100] );
    ispc_swap( data[609], data[101] );
    ispc_swap( data[1632], data[102] );
    ispc_swap( data[1633], data[103] );
    ispc_swap( data[352], data[104] );
    ispc_swap( data[353], data[105] );
    ispc_swap( data[1376], data[106] );
    ispc_swap( data[1377], data[107] );
    ispc_swap( data[864], data[108] );
    ispc_swap( data[865], data[109] );
    ispc_swap( data[1888], data[110] );
    ispc_swap( data[1889], data[111] );
    ispc_swap( data[224], data[112] );
    ispc_swap( data[225], data[113] );
    ispc_swap( data[1248], data[114] );
    ispc_swap( data[1249], data[115] );
    ispc_swap( data[736], data[116] );
    ispc_swap( data[737], data[117] );
    ispc_swap( data[1760], data[118] );
    ispc_swap( data[1761], data[119] );
    ispc_swap( data[480], data[120] );
    ispc_swap( data[481], data[121] );
    ispc_swap( data[1504], data[122] );
    ispc_swap( data[1505], data[123] );
    ispc_swap( data[992], data[124] );
    ispc_swap( data[993], data[125] );
    ispc_swap( data[2016], data[126] );
    ispc_swap( data[2017], data[127] );
    ispc_swap( data[1040], data[130] );
    ispc_swap( data[1041], data[131] );
    ispc_swap( data[528], data[132] );
    ispc_swap( data[529], data[133] );
    ispc_swap( data[1552], data[134] );
    ispc_swap( data[1553], data[135] );
    ispc_swap( data[272], data[136] );
    ispc_swap( data[273], data[137] );
    ispc_swap( data[1296], data[138] );
    ispc_swap( data[1297], data[139] );
    ispc_swap( data[784], data[140] );
    ispc_swap( data[785], data[141] );
    ispc_swap( data[1808], data[142] );
    ispc_swap( data[1809], data[143] );
    ispc_swap( data[1168], data[146] );
    ispc_swap( data[1169], data[147] );
    ispc_swap( data[656], data[148] );
    ispc_swap( data[657], data[149] );
    ispc_swap( data[1680], data[150] );
    ispc_swap( data[1681], data[151] );
    ispc_swap( data[400], data[152] );
    ispc_swap( data[401], data[153] );
    ispc_swap( data[1424], data[154] );
    ispc_swap( data[1425], data[155] );
    ispc_swap( data[912], data[156] );
    ispc_swap( data[913], data[157] );
    ispc_swap( data[1936], data[158] );
    ispc_swap( data[1937], data[159] );
    ispc_swap( data[1104], data[162] );
    ispc_swap( data[1105], data[163] );
    ispc_swap( data[592], data[164] );
    ispc_swap( data[593], data[165] );
    ispc_swap( data[1616], data[166] );
    ispc_swap( data[1617], data[167] );
    ispc_swap( data[336], data[168] );
    ispc_swap( data[337], data[169] );
    ispc_swap( data[1360], data[170] );
    ispc_swap( data[1361], data[171] );
    ispc_swap( data[848], data[172] );
    ispc_swap( data[849], data[173] );
    ispc_swap( data[1872], data[174] );
    ispc_swap( data[1873], data[175] );
    ispc_swap( data[208], data[176] );
    ispc_swap( data[209], data[177] );
    ispc_swap( data[1232], data[178] );
    ispc_swap( data[1233], data[179] );
    ispc_swap( data[720], data[180] );
    ispc_swap( data[721], data[181] );
    ispc_swap( data[1744], data[182] );
    ispc_swap( data[1745], data[183] );
    ispc_swap( data[464], data[184] );
    ispc_swap( data[465], data[185] );
    ispc_swap( data[1488], data[186] );
    ispc_swap( data[1489], data[187] );
    ispc_swap( data[976], data[188] );
    ispc_swap( data[977], data[189] );
    ispc_swap( data[2000], data[190] );
    ispc_swap( data[2001], data[191] );
    ispc_swap( data[1072], data[194] );
    ispc_swap( data[1073], data[195] );
    ispc_swap( data[560], data[196] );
    ispc_swap( data[561], data[197] );
    ispc_swap( data[1584], data[198] );
    ispc_swap( data[1585], data[199] );
    ispc_swap( data[304], data[200] );
    ispc_swap( data[305], data[201] );
    ispc_swap( data[1328], data[202] );
    ispc_swap( data[1329], data[203] );
    ispc_swap( data[816], data[204] );
    ispc_swap( data[817], data[205] );
    ispc_swap( data[1840], data[206] );
    ispc_swap( data[1841], data[207] );
    ispc_swap( data[1200], data[210] );
    ispc_swap( data[1201], data[211] );
    ispc_swap( data[688], data[212] );
    ispc_swap( data[689], data[213] );
    ispc_swap( data[1712], data[214] );
    ispc_swap( data[1713], data[215] );
    ispc_swap( data[432], data[216] );
    ispc_swap( data[433], data[217] );
    ispc_swap( data[1456], data[218] );
    ispc_swap( data[1457], data[219] );
    ispc_swap( data[944], data[220] );
    ispc_swap( data[945], data[221] );
    ispc_swap( data[1968], data[222] );
    ispc_swap( data[1969], data[223] );
    ispc_swap( data[1136], data[226] );
    ispc_swap( data[1137], data[227] );
    ispc_swap( data[624], data[228] );
    ispc_swap( data[625], data[229] );
    ispc_swap( data[1648], data[230] );
    ispc_swap( data[1649], data[231] );
    ispc_swap( data[368], data[232] );
    ispc_swap( data[369], data[233] );
    ispc_swap( data[1392], data[234] );
    ispc_swap( data[1393], data[235] );
    ispc_swap( data[880], data[236] );
    ispc_swap( data[881], data[237] );
    ispc_swap( data[1904], data[238] );
    ispc_swap( data[1905], data[239] );
    ispc_swap( data[1264], data[242] );
    ispc_swap( data[1265], data[243] );
    ispc_swap( data[752], data[244] );
    ispc_swap( data[753], data[245] );
    ispc_swap( data[1776], data[246] );
    ispc_swap( data[1777], data[247] );
    ispc_swap( data[496], data[248] );
    ispc_swap( data[497], data[249] );
    ispc_swap( data[1520], data[250] );
    ispc_swap( data[1521], data[251] );
    ispc_swap( data[1008], data[252] );
    ispc_swap( data[1009], data[253] );
    ispc_swap( data[2032], data[254] );
    ispc_swap( data[2033], data[255] );
    ispc_swap( data[1032], data[258] );
    ispc_swap( data[1033], data[259] );
    ispc_swap( data[520], data[260] );
    ispc_swap( data[521], data[261] );
    ispc_swap( data[1544], data[262] );
    ispc_swap( data[1545], data[263] );
    ispc_swap( data[1288], data[266] );
    ispc_swap( data[1289], data[267] );
    ispc_swap( data[776], data[268] );
    ispc_swap( data[777], data[269] );
    ispc_swap( data[1800], data[270] );
    ispc_swap( data[1801], data[271] );
    ispc_swap( data[1160], data[274] );
    ispc_swap( data[1161], data[275] );
    ispc_swap( data[648], data[276] );
    ispc_swap( data[649], data[277] );
    ispc_swap( data[1672], data[278] );
    ispc_swap( data[1673], data[279] );
    ispc_swap( data[392], data[280] );
    ispc_swap( data[393], data[281] );
    ispc_swap( data[1416], data[282] );
    ispc_swap( data[1417], data[283] );
    ispc_swap( data[904], data[284] );
    ispc_swap( data[905], data[285] );
    ispc_swap( data[1928], data[286] );
    ispc_swap( data[1929], data[287] );
    ispc_swap( data[1096], data[290] );
    ispc_swap( data[1097], data[291] );
    ispc_swap( data[584], data[292] );
    ispc_swap( data[585], data[293] );
    ispc_swap( data[1608], data[294] );
    ispc_swap( data[1609], data[295] );
    ispc_swap( data[328], data[296] );
    ispc_swap( data[329], data[297] );
    ispc_swap( data[1352], data[298] );
    ispc_swap( data[1353], data[299] );
    ispc_swap( data[840], data[300] );
    ispc_swap( data[841], data[301] );
    ispc_swap( data[1864], data[302] );
    ispc_swap( data[1865], data[303] );
    ispc_swap( data[1224], data[306] );
    ispc_swap( data[1225], data[307] );
    ispc_swap( data[712], data[308] );
    ispc_swap( data[713], data[309] );
    ispc_swap( data[1736], data[310] );
    ispc_swap( data[1737], data[311] );
    ispc_swap( data[456], data[312] );
    ispc_swap( data[457], data[313] );
    ispc_swap( data[1480], data[314] );
    ispc_swap( data[1481], data[315] );
    ispc_swap( data[968], data[316] );
    ispc_swap( data[969], data[317] );
    ispc_swap( data[1992], data[318] );
    ispc_swap( data[1993], data[319] );
    ispc_swap( data[1064], data[322] );
    ispc_swap( data[1065], data[323] );
    ispc_swap( data[552], data[324] );
    ispc_swap( data[553], data[325] );
    ispc_swap( data[1576], data[326] );
    ispc_swap( data[1577], data[327] );
    ispc_swap( data[1320], data[330] );
    ispc_swap( data[1321], data[331] );
    ispc_swap( data[808], data[332] );
    ispc_swap( data[809], data[333] );
    ispc_swap( data[1832], data[334] );
    ispc_swap( data[1833], data[335] );
    ispc_swap( data[1192], data[338] );
    ispc_swap( data[1193], data[339] );
    ispc_swap( data[680], data[340] );
    ispc_swap( data[681], data[341] );
    ispc_swap( data[1704], data[342] );
    ispc_swap( data[1705], data[343] );
    ispc_swap( data[424], data[344] );
    ispc_swap( data[425], data[345] );
    ispc_swap( data[1448], data[346] );
    ispc_swap( data[1449], data[347] );
    ispc_swap( data[936], data[348] );
    ispc_swap( data[937], data[349] );
    ispc_swap( data[1960], data[350] );
    ispc_swap( data[1961], data[351] );
    ispc_swap( data[1128], data[354] );
    ispc_swap( data[1129], data[355] );
    ispc_swap( data[616], data[356] );
    ispc_swap( data[617], data[357] );
    ispc_swap( data[1640], data[358] );
    ispc_swap( data[1641], data[359] );
    ispc_swap( data[1384], data[362] );
    ispc_swap( data[1385], data[363] );
    ispc_swap( data[872], data[364] );
    ispc_swap( data[873], data[365] );
    ispc_swap( data[1896], data[366] );
    ispc_swap( data[1897], data[367] );
    ispc_swap( data[1256], data[370] );
    ispc_swap( data[1257], data[371] );
    ispc_swap( data[744], data[372] );
    ispc_swap( data[745], data[373] );
    ispc_swap( data[1768], data[374] );
    ispc_swap( data[1769], data[375] );
    ispc_swap( data[488], data[376] );
    ispc_swap( data[489], data[377] );
    ispc_swap( data[1512], data[378] );
    ispc_swap( data[1513], data[379] );
    ispc_swap( data[1000], data[380] );
    ispc_swap( data[1001], data[381] );
    ispc_swap( data[2024], data[382] );
    ispc_swap( data[2025], data[383] );
    ispc_swap( data[1048], data[386] );
    ispc_swap( data[1049], data[387] );
    ispc_swap( data[536], data[388] );
    ispc_swap( data[537], data[389] );
    ispc_swap( data[1560], data[390] );
    ispc_swap( data[1561], data[391] );
    ispc_swap( data[1304], data[394] );
    ispc_swap( data[1305], data[395] );
    ispc_swap( data[792], data[396] );
    ispc_swap( data[793], data[397] );
    ispc_swap( data[1816], data[398] );
    ispc_swap( data[1817], data[399] );
    ispc_swap( data[1176], data[402] );
    ispc_swap( data[1177], data[403] );
    ispc_swap( data[664], data[404] );
    ispc_swap( data[665], data[405] );
    ispc_swap( data[1688], data[406] );
    ispc_swap( data[1689], data[407] );
    ispc_swap( data[1432], data[410] );
    ispc_swap( data[1433], data[411] );
    ispc_swap( data[920], data[412] );
    ispc_swap( data[921], data[413] );
    ispc_swap( data[1944], data[414] );
    ispc_swap( data[1945], data[415] );
    ispc_swap( data[1112], data[418] );
    ispc_swap( data[1113], data[419] );
    ispc_swap( data[600], data[420] );
    ispc_swap( data[601], data[421] );
    ispc_swap( data[1624], data[422] );
    ispc_swap( data[1625], data[423] );
    ispc_swap( data[1368], data[426] );
    ispc_swap( data[1369], data[427] );
    ispc_swap( data[856], data[428] );
    ispc_swap( data[857], data[429] );
    ispc_swap( data[1880], data[430] );
    ispc_swap( data[1881], data[431] );
    ispc_swap( data[1240], data[434] );
    ispc_swap( data[1241], data[435] );
    ispc_swap( data[728], data[436] );
    ispc_swap( data[729], data[437] );
    ispc_swap( data[1752], data[438] );
    ispc_swap( data[1753], data[439] );
    ispc_swap( data[472], data[440] );
    ispc_swap( data[473], data[441] );
    ispc_swap( data[1496], data[442] );
    ispc_swap( data[1497], data[443] );
    ispc_swap( data[984], data[444] );
    ispc_swap( data[985], data[445] );
    ispc_swap( data[2008], data[446] );
    ispc_swap( data[2009], data[447] );
    ispc_swap( data[1080], data[450] );
    ispc_swap( data[1081], data[451] );
    ispc_swap( data[568], data[452] );
    ispc_swap( data[569], data[453] );
    ispc_swap( data[1592], data[454] );
    ispc_swap( data[1593], data[455] );
    ispc_swap( data[1336], data[458] );
    ispc_swap( data[1337], data[459] );
    ispc_swap( data[824], data[460] );
    ispc_swap( data[825], data[461] );
    ispc_swap( data[1848], data[462] );
    ispc_swap( data[1849], data[463] );
    ispc_swap( data[1208], data[466] );
    ispc_swap( data[1209], data[467] );
    ispc_swap( data[696], data[468] );
    ispc_swap( data[697], data[469] );
    ispc_swap( data[1720], data[470] );
    ispc_swap( data[1721], data[471] );
    ispc_swap( data[1464], data[474] );
    ispc_swap( data[1465], data[475] );
    ispc_swap( data[952], data[476] );
    ispc_swap( data[953], data[477] );
    ispc_swap( data[1976], data[478] );
    ispc_swap( data[1977], data[479] );
    ispc_swap( data[1144], data[482] );
    ispc_swap( data[1145], data[483] );
    ispc_swap( data[632], data[484] );
    ispc_swap( data[633], data[485] );
    ispc_swap( data[1656], data[486] );
    ispc_swap( data[1657], data[487] );
    ispc_swap( data[1400], data[490] );
    ispc_swap( data[1401], data[491] );
    ispc_swap( data[888], data[492] );
    ispc_swap( data[889], data[493] );
    ispc_swap( data[1912], data[494] );
    ispc_swap( data[1913], data[495] );
    ispc_swap( data[1272], data[498] );
    ispc_swap( data[1273], data[499] );
    ispc_swap( data[760], data[500] );
    ispc_swap( data[761], data[501] );
    ispc_swap( data[1784], data[502] );
    ispc_swap( data[1785], data[503] );
    ispc_swap( data[1528], data[506] );
    ispc_swap( data[1529], data[507] );
    ispc_swap( data[1016], data[508] );
    ispc_swap( data[1017], data[509] );
    ispc_swap( data[2040], data[510] );
    ispc_swap( data[2041], data[511] );
    ispc_swap( data[1028], data[514] );
    ispc_swap( data[1029], data[515] );
    ispc_swap( data[1540], data[518] );
    ispc_swap( data[1541], data[519] );
    ispc_swap( data[1284], data[522] );
    ispc_swap( data[1285], data[523] );
    ispc_swap( data[772], data[524] );
    ispc_swap( data[773], data[525] );
    ispc_swap( data[1796], data[526] );
    ispc_swap( data[1797], data[527] );
    ispc_swap( data[1156], data[530] );
    ispc_swap( data[1157], data[531] );
    ispc_swap( data[644], data[532] );
    ispc_swap( data[645], data[533] );
    ispc_swap( data[1668], data[534] );
    ispc_swap( data[1669], data[535] );
    ispc_swap( data[1412], data[538] );
    ispc_swap( data[1413], data[539] );
    ispc_swap( data[900], data[540] );
    ispc_swap( data[901], data[541] );
    ispc_swap( data[1924], data[542] );
    ispc_swap( data[1925], data[543] );
    ispc_swap( data[1092], data[546] );
    ispc_swap( data[1093], data[547] );
    ispc_swap( data[580], data[548] );
    ispc_swap( data[581], data[549] );
    ispc_swap( data[1604], data[550] );
    ispc_swap( data[1605], data[551] );
    ispc_swap( data[1348], data[554] );
    ispc_swap( data[1349], data[555] );
    ispc_swap( data[836], data[556] );
    ispc_swap( data[837], data[557] );
    ispc_swap( data[1860], data[558] );
    ispc_swap( data[1861], data[559] );
    ispc_swap( data[1220], data[562] );
    ispc_swap( data[1221], data[563] );
    ispc_swap( data[708], data[564] );
    ispc_swap( data[709], data[565] );
    ispc_swap( data[1732], data[566] );
    ispc_swap( data[1733], data[567] );
    ispc_swap( data[1476], data[570] );
    ispc_swap( data[1477], data[571] );
    ispc_swap( data[964], data[572] );
    ispc_swap( data[965], data[573] );
    ispc_swap( data[1988], data[574] );
    ispc_swap( data[1989], data[575] );
    ispc_swap( data[1060], data[578] );
    ispc_swap( data[1061], data[579] );
    ispc_swap( data[1572], data[582] );
    ispc_swap( data[1573], data[583] );
    ispc_swap( data[1316], data[586] );
    ispc_swap( data[1317], data[587] );
    ispc_swap( data[804], data[588] );
    ispc_swap( data[805], data[589] );
    ispc_swap( data[1828], data[590] );
    ispc_swap( data[1829], data[591] );
    ispc_swap( data[1188], data[594] );
    ispc_swap( data[1189], data[595] );
    ispc_swap( data[676], data[596] );
    ispc_swap( data[677], data[597] );
    ispc_swap( data[1700], data[598] );
    ispc_swap( data[1701], data[599] );
    ispc_swap( data[1444], data[602] );
    ispc_swap( data[1445], data[603] );
    ispc_swap( data[932], data[604] );
    ispc_swap( data[933], data[605] );
    ispc_swap( data[1956], data[606] );
    ispc_swap( data[1957], data[607] );
    ispc_swap( data[1124], data[610] );
    ispc_swap( data[1125], data[611] );
    ispc_swap( data[1636], data[614] );
    ispc_swap( data[1637], data[615] );
    ispc_swap( data[1380], data[618] );
    ispc_swap( data[1381], data[619] );
    ispc_swap( data[868], data[620] );
    ispc_swap( data[869], data[621] );
    ispc_swap( data[1892], data[622] );
    ispc_swap( data[1893], data[623] );
    ispc_swap( data[1252], data[626] );
    ispc_swap( data[1253], data[627] );
    ispc_swap( data[740], data[628] );
    ispc_swap( data[741], data[629] );
    ispc_swap( data[1764], data[630] );
    ispc_swap( data[1765], data[631] );
    ispc_swap( data[1508], data[634] );
    ispc_swap( data[1509], data[635] );
    ispc_swap( data[996], data[636] );
    ispc_swap( data[997], data[637] );
    ispc_swap( data[2020], data[638] );
    ispc_swap( data[2021], data[639] );
    ispc_swap( data[1044], data[642] );
    ispc_swap( data[1045], data[643] );
    ispc_swap( data[1556], data[646] );
    ispc_swap( data[1557], data[647] );
    ispc_swap( data[1300], data[650] );
    ispc_swap( data[1301], data[651] );
    ispc_swap( data[788], data[652] );
    ispc_swap( data[789], data[653] );
    ispc_swap( data[1812], data[654] );
    ispc_swap( data[1813], data[655] );
    ispc_swap( data[1172], data[658] );
    ispc_swap( data[1173], data[659] );
    ispc_swap( data[1684], data[662] );
    ispc_swap( data[1685], data[663] );
    ispc_swap( data[1428], data[666] );
    ispc_swap( data[1429], data[667] );
    ispc_swap( data[916], data[668] );
    ispc_swap( data[917], data[669] );
    ispc_swap( data[1940], data[670] );
    ispc_swap( data[1941], data[671] );
    ispc_swap( data[1108], data[674] );
    ispc_swap( data[1109], data[675] );
    ispc_swap( data[1620], data[678] );
    ispc_swap( data[1621], data[679] );
    ispc_swap( data[1364], data[682] );
    ispc_swap( data[1365], data[683] );
    ispc_swap( data[852], data[684] );
    ispc_swap( data[853], data[685] );
    ispc_swap( data[1876], data[686] );
    ispc_swap( data[1877], data[687] );
    ispc_swap( data[1236], data[690] );
    ispc_swap( data[1237], data[691] );
    ispc_swap( data[724], data[692] );
    ispc_swap( data[725], data[693] );
    ispc_swap( data[1748], data[694] );
    ispc_swap( data[1749], data[695] );
    ispc_swap( data[1492], data[698] );
    ispc_swap( data[1493], data[699] );
    ispc_swap( data[980], data[700] );
    ispc_swap( data[981], data[701] );
    ispc_swap( data[2004], data[702] );
    ispc_swap( data[2005], data[703] );
    ispc_swap( data[1076], data[706] );
    ispc_swap( data[1077], data[707] );
    ispc_swap( data[1588], data[710] );
    ispc_swap( data[1589], data[711] );
    ispc_swap( data[1332], data[714] );
    ispc_swap( data[1333], data[715] );
    ispc_swap( data[820], data[716] );
    ispc_swap( data[821], data[717] );
    ispc_swap( data[1844], data[718] );
    ispc_swap( data[1845], data[719] );
    ispc_swap( data[1204], data[722] );
    ispc_swap( data[1205], data[723] );
    ispc_swap( data[1716], data[726] );
    ispc_swap( data[1717], data[727] );
    ispc_swap( data[1460], data[730] );
    ispc_swap( data[1461], data[731] );
    ispc_swap( data[948], data[732] );
    ispc_swap( data[949], data[733] );
    ispc_swap( data[1972], data[734] );
    ispc_swap( data[1973], data[735] );
    ispc_swap( data[1140], data[738] );
    ispc_swap( data[1141], data[739] );
    ispc_swap( data[1652], data[742] );
    ispc_swap( data[1653], data[743] );
    ispc_swap( data[1396], data[746] );
    ispc_swap( data[1397], data[747] );
    ispc_swap( data[884], data[748] );
    ispc_swap( data[885], data[749] );
    ispc_swap( data[1908], data[750] );
    ispc_swap( data[1909], data[751] );
    ispc_swap( data[1268], data[754] );
    ispc_swap( data[1269], data[755] );
    ispc_swap( data[1780], data[758] );
    ispc_swap( data[1781], data[759] );
    ispc_swap( data[1524], data[762] );
    ispc_swap( data[1525], data[763] );
    ispc_swap( data[1012], data[764] );
    ispc_swap( data[1013], data[765] );
    ispc_swap( data[2036], data[766] );
    ispc_swap( data[2037], data[767] );
    ispc_swap( data[1036], data[770] );
    ispc_swap( data[1037], data[771] );
    ispc_swap( data[1548], data[774] );
    ispc_swap( data[1549], data[775] );
    ispc_swap( data[1292], data[778] );
    ispc_swap( data[1293], data[779] );
    ispc_swap( data[1804], data[782] );
    ispc_swap( data[1805], data[783] );
    ispc_swap( data[1164], data[786] );
    ispc_swap( data[1165], data[787] );
    ispc_swap( data[1676], data[790] );
    ispc_swap( data[1677], data[791] );
    ispc_swap( data[1420], data[794] );
    ispc_swap( data[1421], data[795] );
    ispc_swap( data[908], data[796] );
    ispc_swap( data[909], data[797] );
    ispc_swap( data[1932], data[798] );
    ispc_swap( data[1933], data[799] );
    ispc_swap( data[1100], data[802] );
    ispc_swap( data[1101], data[803] );
    ispc_swap( data[1612], data[806] );
    ispc_swap( data[1613], data[807] );
    ispc_swap( data[1356], data[810] );
    ispc_swap( data[1357], data[811] );
    ispc_swap( data[844], data[812] );
    ispc_swap( data[845], data[813] );
    ispc_swap( data[1868], data[814] );
    ispc_swap( data[1869], data[815] );
    ispc_swap( data[1228], data[818] );
    ispc_swap( data[1229], data[819] );
    ispc_swap( data[1740], data[822] );
    ispc_swap( data[1741], data[823] );
    ispc_swap( data[1484], data[826] );
    ispc_swap( data[1485], data[827] );
    ispc_swap( data[972], data[828] );
    ispc_swap( data[973], data[829] );
    ispc_swap( data[1996], data[830] );
    ispc_swap( data[1997], data[831] );
    ispc_swap( data[1068], data[834] );
    ispc_swap( data[1069], data[835] );
    ispc_swap( data[1580], data[838] );
    ispc_swap( data[1581], data[839] );
    ispc_swap( data[1324], data[842] );
    ispc_swap( data[1325], data[843] );
    ispc_swap( data[1836], data[846] );
    ispc_swap( data[1837], data[847] );
    ispc_swap( data[1196], data[850] );
    ispc_swap( data[1197], data[851] );
    ispc_swap( data[1708], data[854] );
    ispc_swap( data[1709], data[855] );
    ispc_swap( data[1452], data[858] );
    ispc_swap( data[1453], data[859] );
    ispc_swap( data[940], data[860] );
    ispc_swap( data[941], data[861] );
    ispc_swap( data[1964], data[862] );
    ispc_swap( data[1965], data[863] );
    ispc_swap( data[1132], data[866] );
    ispc_swap( data[1133], data[867] );
    ispc_swap( data[1644], data[870] );
    ispc_swap( data[1645], data[871] );
    ispc_swap( data[1388], data[874] );
    ispc_swap( data[1389], data[875] );
    ispc_swap( data[1900], data[878] );
    ispc_swap( data[1901], data[879] );
    ispc_swap( data[1260], data[882] );
    ispc_swap( data[1261], data[883] );
    ispc_swap( data[1772], data[886] );
    ispc_swap( data[1773], data[887] );
    ispc_swap( data[1516], data[890] );
    ispc_swap( data[1517], data[891] );
    ispc_swap( data[1004], data[892] );
    ispc_swap( data[1005], data[893] );
    ispc_swap( data[2028], data[894] );
    ispc_swap( data[2029], data[895] );
    ispc_swap( data[1052], data[898] );
    ispc_swap( data[1053], data[899] );
    ispc_swap( data[1564], data[902] );
    ispc_swap( data[1565], data[903] );
    ispc_swap( data[1308], data[906] );
    ispc_swap( data[1309], data[907] );
    ispc_swap( data[1820], data[910] );
    ispc_swap( data[1821], data[911] );
    ispc_swap( data[1180], data[914] );
    ispc_swap( data[1181], data[915] );
    ispc_swap( data[1692], data[918] );
    ispc_swap( data[1693], data[919] );
    ispc_swap( data[1436], data[922] );
    ispc_swap( data[1437], data[923] );
    ispc_swap( data[1948], data[926] );
    ispc_swap( data[1949], data[927] );
    ispc_swap( data[1116], data[930] );
    ispc_swap( data[1117], data[931] );
    ispc_swap( data[1628], data[934] );
    ispc_swap( data[1629], data[935] );
    ispc_swap( data[1372], data[938] );
    ispc_swap( data[1373], data[939] );
    ispc_swap( data[1884], data[942] );
    ispc_swap( data[1885], data[943] );
    ispc_swap( data[1244], data[946] );
    ispc_swap( data[1245], data[947] );
    ispc_swap( data[1756], data[950] );
    ispc_swap( data[1757], data[951] );
    ispc_swap( data[1500], data[954] );
    ispc_swap( data[1501], data[955] );
    ispc_swap( data[988], data[956] );
    ispc_swap( data[989], data[957] );
    ispc_swap( data[2012], data[958] );
    ispc_swap( data[2013], data[959] );
    ispc_swap( data[1084], data[962] );
    ispc_swap( data[1085], data[963] );
    ispc_swap( data[1596], data[966] );
    ispc_swap( data[1597], data[967] );
    ispc_swap( data[1340], data[970] );
    ispc_swap( data[1341], data[971] );
    ispc_swap( data[1852], data[974] );
    ispc_swap( data[1853], data[975] );
    ispc_swap( data[1212], data[978] );
    ispc_swap( data[1213], data[979] );
    ispc_swap( data[1724], data[982] );
    ispc_swap( data[1725], data[983] );
    ispc_swap( data[1468], data[986] );
    ispc_swap( data[1469], data[987] );
    ispc_swap( data[1980], data[990] );
    ispc_swap( data[1981], data[991] );
    ispc_swap( data[1148], data[994] );
    ispc_swap( data[1149], data[995] );
    ispc_swap( data[1660], data[998] );
    ispc_swap( data[1661], data[999] );
    ispc_swap( data[1404], data[1002] );
    ispc_swap( data[1405], data[1003] );
    ispc_swap( data[1916], data[1006] );
    ispc_swap( data[1917], data[1007] );
    ispc_swap( data[1276], data[1010] );
    ispc_swap( data[1277], data[1011] );
    ispc_swap( data[1788], data[1014] );
    ispc_swap( data[1789], data[1015] );
    ispc_swap( data[1532], data[1018] );
    ispc_swap( data[1533], data[1019] );
    ispc_swap( data[2044], data[1022] );
    ispc_swap( data[2045], data[1023] );
    ispc_swap( data[1538], data[1030] );
    ispc_swap( data[1539], data[1031] );
    ispc_swap( data[1282], data[1034] );
    ispc_swap( data[1283], data[1035] );
    ispc_swap( data[1794], data[1038] );
    ispc_swap( data[1795], data[1039] );
    ispc_swap( data[1154], data[1042] );
    ispc_swap( data[1155], data[1043] );
    ispc_swap( data[1666], data[1046] );
    ispc_swap( data[1667], data[1047] );
    ispc_swap( data[1410], data[1050] );
    ispc_swap( data[1411], data[1051] );
    ispc_swap( data[1922], data[1054] );
    ispc_swap( data[1923], data[1055] );
    ispc_swap( data[1090], data[1058] );
    ispc_swap( data[1091], data[1059] );
    ispc_swap( data[1602], data[1062] );
    ispc_swap( data[1603], data[1063] );
    ispc_swap( data[1346], data[1066] );
    ispc_swap( data[1347], data[1067] );
    ispc_swap( data[1858], data[1070] );
    ispc_swap( data[1859], data[1071] );
    ispc_swap( data[1218], data[1074] );
    ispc_swap( data[1219], data[1075] );
    ispc_swap( data[1730], data[1078] );
    ispc_swap( data[1731], data[1079] );
    ispc_swap( data[1474], data[1082] );
    ispc_swap( data[1475], data[1083] );
    ispc_swap( data[1986], data[1086] );
    ispc_swap( data[1987], data[1087] );
    ispc_swap( data[1570], data[1094] );
    ispc_swap( data[1571], data[1095] );
    ispc_swap( data[1314], data[1098] );
    ispc_swap( data[1315], data[1099] );
    ispc_swap( data[1826], data[1102] );
    ispc_swap( data[1827], data[1103] );
    ispc_swap( data[1186], data[1106] );
    ispc_swap( data[1187], data[1107] );
    ispc_swap( data[1698], data[1110] );
    ispc_swap( data[1699], data[1111] );
    ispc_swap( data[1442], data[1114] );
    ispc_swap( data[1443], data[1115] );
    ispc_swap( data[1954], data[1118] );
    ispc_swap( data[1955], data[1119] );
    ispc_swap( data[1634], data[1126] );
    ispc_swap( data[1635], data[1127] );
    ispc_swap( data[1378], data[1130] );
    ispc_swap( data[1379], data[1131] );
    ispc_swap( data[1890], data[1134] );
    ispc_swap( data[1891], data[1135] );
    ispc_swap( data[1250], data[1138] );
    ispc_swap( data[1251], data[1139] );
    ispc_swap( data[1762], data[1142] );
    ispc_swap( data[1763], data[1143] );
    ispc_swap( data[1506], data[1146] );
    ispc_swap( data[1507], data[1147] );
    ispc_swap( data[2018], data[1150] );
    ispc_swap( data[2019], data[1151] );
    ispc_swap( data[1554], data[1158] );
    ispc_swap( data[1555], data[1159] );
    ispc_swap( data[1298], data[1162] );
    ispc_swap( data[1299], data[1163] );
    ispc_swap( data[1810], data[1166] );
    ispc_swap( data[1811], data[1167] );
    ispc_swap( data[1682], data[1174] );
    ispc_swap( data[1683], data[1175] );
    ispc_swap( data[1426], data[1178] );
    ispc_swap( data[1427], data[1179] );
    ispc_swap( data[1938], data[1182] );
    ispc_swap( data[1939], data[1183] );
    ispc_swap( data[1618], data[1190] );
    ispc_swap( data[1619], data[1191] );
    ispc_swap( data[1362], data[1194] );
    ispc_swap( data[1363], data[1195] );
    ispc_swap( data[1874], data[1198] );
    ispc_swap( data[1875], data[1199] );
    ispc_swap( data[1234], data[1202] );
    ispc_swap( data[1235], data[1203] );
    ispc_swap( data[1746], data[1206] );
    ispc_swap( data[1747], data[1207] );
    ispc_swap( data[1490], data[1210] );
    ispc_swap( data[1491], data[1211] );
    ispc_swap( data[2002], data[1214] );
    ispc_swap( data[2003], data[1215] );
    ispc_swap( data[1586], data[1222] );
    ispc_swap( data[1587], data[1223] );
    ispc_swap( data[1330], data[1226] );
    ispc_swap( data[1331], data[1227] );
    ispc_swap( data[1842], data[1230] );
    ispc_swap( data[1843], data[1231] );
    ispc_swap( data[1714], data[1238] );
    ispc_swap( data[1715], data[1239] );
    ispc_swap( data[1458], data[1242] );
    ispc_swap( data[1459], data[1243] );
    ispc_swap( data[1970], data[1246] );
    ispc_swap( data[1971], data[1247] );
    ispc_swap( data[1650], data[1254] );
    ispc_swap( data[1651], data[1255] );
    ispc_swap( data[1394], data[1258] );
    ispc_swap( data[1395], data[1259] );
    ispc_swap( data[1906], data[1262] );
    ispc_swap( data[1907], data[1263] );
    ispc_swap( data[1778], data[1270] );
    ispc_swap( data[1779], data[1271] );
    ispc_swap( data[1522], data[1274] );
    ispc_swap( data[1523], data[1275] );
    ispc_swap( data[2034], data[1278] );
    ispc_swap( data[2035], data[1279] );
    ispc_swap( data[1546], data[1286] );
    ispc_swap( data[1547], data[1287] );
    ispc_swap( data[1802], data[1294] );
    ispc_swap( data[1803], data[1295] );
    ispc_swap( data[1674], data[1302] );
    ispc_swap( data[1675], data[1303] );
    ispc_swap( data[1418], data[1306] );
    ispc_swap( data[1419], data[1307] );
    ispc_swap( data[1930], data[1310] );
    ispc_swap( data[1931], data[1311] );
    ispc_swap( data[1610], data[1318] );
    ispc_swap( data[1611], data[1319] );
    ispc_swap( data[1354], data[1322] );
    ispc_swap( data[1355], data[1323] );
    ispc_swap( data[1866], data[1326] );
    ispc_swap( data[1867], data[1327] );
    ispc_swap( data[1738], data[1334] );
    ispc_swap( data[1739], data[1335] );
    ispc_swap( data[1482], data[1338] );
    ispc_swap( data[1483], data[1339] );
    ispc_swap( data[1994], data[1342] );
    ispc_swap( data[1995], data[1343] );
    ispc_swap( data[1578], data[1350] );
    ispc_swap( data[1579], data[1351] );
    ispc_swap( data[1834], data[1358] );
    ispc_swap( data[1835], data[1359] );
    ispc_swap( data[1706], data[1366] );
    ispc_swap( data[1707], data[1367] );
    ispc_swap( data[1450], data[1370] );
    ispc_swap( data[1451], data[1371] );
    ispc_swap( data[1962], data[1374] );
    ispc_swap( data[1963], data[1375] );
    ispc_swap( data[1642], data[1382] );
    ispc_swap( data[1643], data[1383] );
    ispc_swap( data[1898], data[1390] );
    ispc_swap( data[1899], data[1391] );
    ispc_swap( data[1770], data[1398] );
    ispc_swap( data[1771], data[1399] );
    ispc_swap( data[1514], data[1402] );
    ispc_swap( data[1515], data[1403] );
    ispc_swap( data[2026], data[1406] );
    ispc_swap( data[2027], data[1407] );
    ispc_swap( data[1562], data[1414] );
    ispc_swap( data[1563], data[1415] );
    ispc_swap( data[1818], data[1422] );
    ispc_swap( data[1819], data[1423] );
    ispc_swap( data[1690], data[1430] );
    ispc_swap( data[1691], data[1431] );
    ispc_swap( data[1946], data[1438] );
    ispc_swap( data[1947], data[1439] );
    ispc_swap( data[1626], data[1446] );
    ispc_swap( data[1627], data[1447] );
    ispc_swap( data[1882], data[1454] );
    ispc_swap( data[1883], data[1455] );
    ispc_swap( data[1754], data[1462] );
    ispc_swap( data[1755], data[1463] );
    ispc_swap( data[1498], data[1466] );
    ispc_swap( data[1499], data[1467] );
    ispc_swap( data[2010], data[1470] );
    ispc_swap( data[2011], data[1471] );
    ispc_swap( data[1594], data[1478] );
    ispc_swap( data[1595], data[1479] );
    ispc_swap( data[1850], data[1486] );
    ispc_swap( data[1851], data[1487] );
    ispc_swap( data[1722], data[1494] );
    ispc_swap( data[1723], data[1495] );
    ispc_swap( data[1978], data[1502] );
    ispc_swap( data[1979], data[1503] );
    ispc_swap( data[1658], data[1510] );
    ispc_swap( data[1659], data[1511] );
    ispc_swap( data[1914], data[1518] );
    ispc_swap( data[1915], data[1519] );
    ispc_swap( data[1786], data[1526] );
    ispc_swap( data[1787], data[1527] );
    ispc_swap( data[2042], data[1534] );
    ispc_swap( data[2043], data[1535] );
    ispc_swap( data[1798], data[1550] );
    ispc_swap( data[1799], data[1551] );
    ispc_swap( data[1670], data[1558] );
    ispc_swap( data[1671], data[1559] );
    ispc_swap( data[1926], data[1566] );
    ispc_swap( data[1927], data[1567] );
    ispc_swap( data[1606], data[1574] );
    ispc_swap( data[1607], data[1575] );
    ispc_swap( data[1862], data[1582] );
    ispc_swap( data[1863], data[1583] );
    ispc_swap( data[1734], data[1590] );
    ispc_swap( data[1735], data[1591] );
    ispc_swap( data[1990], data[1598] );
    ispc_swap( data[1991], data[1599] );
    ispc_swap( data[1830], data[1614] );
    ispc_swap( data[1831], data[1615] );
    ispc_swap( data[1702], data[1622] );
    ispc_swap( data[1703], data[1623] );
    ispc_swap( data[1958], data[1630] );
    ispc_swap( data[1959], data[1631] );
    ispc_swap( data[1894], data[1646] );
    ispc_swap( data[1895], data[1647] );
    ispc_swap( data[1766], data[1654] );
    ispc_swap( data[1767], data[1655] );
    ispc_swap( data[2022], data[1662] );
    ispc_swap( data[2023], data[1663] );
    ispc_swap( data[1814], data[1678] );
    ispc_swap( data[1815], data[1679] );
    ispc_swap( data[1942], data[1694] );
    ispc_swap( data[1943], data[1695] );
    ispc_swap( data[1878], data[1710] );
    ispc_swap( data[1879], data[1711] );
    ispc_swap( data[1750], data[1718] );
    ispc_swap( data[1751], data[1719] );
    ispc_swap( data[2006], data[1726] );
    ispc_swap( data[2007], data[1727] );
    ispc_swap( data[1846], data[1742] );
    ispc_swap( data[1847], data[1743] );
    ispc_swap( data[1974], data[1758] );
    ispc_swap( data[1975], data[1759] );
    ispc_swap( data[1910], data[1774] );
    ispc_swap( data[1911], data[1775] );
    ispc_swap( data[2038], data[1790] );
    ispc_swap( data[2039], data[1791] );
    ispc_swap( data[1934], data[1822] );
    ispc_swap( data[1935], data[1823] );
    ispc_swap( data[1870], data[1838] );
    ispc_swap( data[1871], data[1839] );
    ispc_swap( data[1998], data[1854] );
    ispc_swap( data[1999], data[1855] );
    ispc_swap( data[1966], data[1886] );
    ispc_swap( data[1967], data[1887] );
    ispc_swap( data[2030], data[1918] );
    ispc_swap( data[2031], data[1919] );
    ispc_swap( data[2014], data[1982] );
    ispc_swap( data[2015], data[1983] );

    // N = 4, at 0
    {
        uniform float tr = data[2];
        uniform float ti = data[3];
        data[2] = data[0] - tr;
        data[3] = data[1] - ti;
        data[0] += tr;
        data[1] += ti;
        tr = data[6];
        ti = data[7];
        data[6] = data[5] - ti;
        data[7] = tr - data[4];
        data[4] += tr;
        data[5] += ti;
        tr = data[4];
        ti = data[5];
        data[4] = data[0] - tr;
        data[5] = data[1] - ti;
        data[0] += tr;
        data[1] += ti;
        tr = data[6];
        ti = data[7];
        data[6] = data[2] - tr;
        data[7] = data[3] - ti;
        data[2] += tr;
        data[3] += ti;
    }
    // N = 4, at 8
    {
        uniform float tr = data[10];
        uniform float ti = data[11];
        data[10] = data[8] - tr;
        data[11] = data[9] - ti;
        data[8] += tr;
        data[9] += ti;
        tr = data[14];
        ti = data[15];
        data[14] = data[13] - ti;
        data[15] = tr - data[12];
        data[12] += tr;
        data[13] += ti;
        tr = data[12];
        ti = data[13];
        data[12] = data[8] - tr;
        data[13] = data[9] - ti;
        data[8] += tr;
        data[9] += ti;
        tr = data[14];
        ti = data[15];
        data[14] = data[10] - tr;
        data[15] = data[11] - ti;
        data[10] += tr;
        data[11] += ti;
    }
    // N = 8, at 0
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 8 ] * wr - data[ i + 9 ] * wi;
            uniform float tempi  = data[ i + 8 ] * wi + data[ i + 9 ] * wr;
            uniform float tempr2 = data[ i + 10 ] * wr2 - data[ i + 11 ] * wi2;
            uniform float tempi2 = data[ i + 10 ] * wi2 + data[ i + 11 ] * wr2;
            data[ i + 8 ] = data[ 0 + i ] - tempr;
            data[ i + 9 ] = data[ 1 + i ] - tempi;
            data[ i + 10 ] = data[ 2 + i ] - tempr2;
            data[ i + 11 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 16
    {
        uniform float tr = data[18];
        uniform float ti = data[19];
        data[18] = data[16] - tr;
        data[19] = data[17] - ti;
        data[16] += tr;
        data[17] += ti;
        tr = data[22];
        ti = data[23];
        data[22] = data[21] - ti;
        data[23] = tr - data[20];
        data[20] += tr;
        data[21] += ti;
        tr = data[20];
        ti = data[21];
        data[20] = data[16] - tr;
        data[21] = data[17] - ti;
        data[16] += tr;
        data[17] += ti;
        tr = data[22];
        ti = data[23];
        data[22] = data[18] - tr;
        data[23] = data[19] - ti;
        data[18] += tr;
        data[19] += ti;
    }
    // N = 4, at 24
    {
        uniform float tr = data[26];
        uniform float ti = data[27];
        data[26] = data[24] - tr;
        data[27] = data[25] - ti;
        data[24] += tr;
        data[25] += ti;
        tr = data[30];
        ti = data[31];
        data[30] = data[29] - ti;
        data[31] = tr - data[28];
        data[28] += tr;
        data[29] += ti;
        tr = data[28];
        ti = data[29];
        data[28] = data[24] - tr;
        data[29] = data[25] - ti;
        data[24] += tr;
        data[25] += ti;
        tr = data[30];
        ti = data[31];
        data[30] = data[26] - tr;
        data[31] = data[27] - ti;
        data[26] += tr;
        data[27] += ti;
    }
    // N = 8, at 16
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 24 ] * wr - data[ i + 25 ] * wi;
            uniform float tempi  = data[ i + 24 ] * wi + data[ i + 25 ] * wr;
            uniform float tempr2 = data[ i + 26 ] * wr2 - data[ i + 27 ] * wi2;
            uniform float tempi2 = data[ i + 26 ] * wi2 + data[ i + 27 ] * wr2;
            data[ i + 24 ] = data[ 16 + i ] - tempr;
            data[ i + 25 ] = data[ 17 + i ] - tempi;
            data[ i + 26 ] = data[ 18 + i ] - tempr2;
            data[ i + 27 ] = data[ 19 + i ] - tempi2;
            data[ 16 + i ] += tempr;
            data[ 17 + i ] += tempi;
            data[ 18 + i ] += tempr2;
            data[ 19 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 0
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 16 ] * wr - data[ i + 17 ] * wi;
            uniform float tempi  = data[ i + 16 ] * wi + data[ i + 17 ] * wr;
            uniform float tempr2 = data[ i + 18 ] * wr2 - data[ i + 19 ] * wi2;
            uniform float tempi2 = data[ i + 18 ] * wi2 + data[ i + 19 ] * wr2;
            data[ i + 16 ] = data[ 0 + i ] - tempr;
            data[ i + 17 ] = data[ 1 + i ] - tempi;
            data[ i + 18 ] = data[ 2 + i ] - tempr2;
            data[ i + 19 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 32
    {
        uniform float tr = data[34];
        uniform float ti = data[35];
        data[34] = data[32] - tr;
        data[35] = data[33] - ti;
        data[32] += tr;
        data[33] += ti;
        tr = data[38];
        ti = data[39];
        data[38] = data[37] - ti;
        data[39] = tr - data[36];
        data[36] += tr;
        data[37] += ti;
        tr = data[36];
        ti = data[37];
        data[36] = data[32] - tr;
        data[37] = data[33] - ti;
        data[32] += tr;
        data[33] += ti;
        tr = data[38];
        ti = data[39];
        data[38] = data[34] - tr;
        data[39] = data[35] - ti;
        data[34] += tr;
        data[35] += ti;
    }
    // N = 4, at 40
    {
        uniform float tr = data[42];
        uniform float ti = data[43];
        data[42] = data[40] - tr;
        data[43] = data[41] - ti;
        data[40] += tr;
        data[41] += ti;
        tr = data[46];
        ti = data[47];
        data[46] = data[45] - ti;
        data[47] = tr - data[44];
        data[44] += tr;
        data[45] += ti;
        tr = data[44];
        ti = data[45];
        data[44] = data[40] - tr;
        data[45] = data[41] - ti;
        data[40] += tr;
        data[41] += ti;
        tr = data[46];
        ti = data[47];
        data[46] = data[42] - tr;
        data[47] = data[43] - ti;
        data[42] += tr;
        data[43] += ti;
    }
    // N = 8, at 32
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 40 ] * wr - data[ i + 41 ] * wi;
            uniform float tempi  = data[ i + 40 ] * wi + data[ i + 41 ] * wr;
            uniform float tempr2 = data[ i + 42 ] * wr2 - data[ i + 43 ] * wi2;
            uniform float tempi2 = data[ i + 42 ] * wi2 + data[ i + 43 ] * wr2;
            data[ i + 40 ] = data[ 32 + i ] - tempr;
            data[ i + 41 ] = data[ 33 + i ] - tempi;
            data[ i + 42 ] = data[ 34 + i ] - tempr2;
            data[ i + 43 ] = data[ 35 + i ] - tempi2;
            data[ 32 + i ] += tempr;
            data[ 33 + i ] += tempi;
            data[ 34 + i ] += tempr2;
            data[ 35 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 48
    {
        uniform float tr = data[50];
        uniform float ti = data[51];
        data[50] = data[48] - tr;
        data[51] = data[49] - ti;
        data[48] += tr;
        data[49] += ti;
        tr = data[54];
        ti = data[55];
        data[54] = data[53] - ti;
        data[55] = tr - data[52];
        data[52] += tr;
        data[53] += ti;
        tr = data[52];
        ti = data[53];
        data[52] = data[48] - tr;
        data[53] = data[49] - ti;
        data[48] += tr;
        data[49] += ti;
        tr = data[54];
        ti = data[55];
        data[54] = data[50] - tr;
        data[55] = data[51] - ti;
        data[50] += tr;
        data[51] += ti;
    }
    // N = 4, at 56
    {
        uniform float tr = data[58];
        uniform float ti = data[59];
        data[58] = data[56] - tr;
        data[59] = data[57] - ti;
        data[56] += tr;
        data[57] += ti;
        tr = data[62];
        ti = data[63];
        data[62] = data[61] - ti;
        data[63] = tr - data[60];
        data[60] += tr;
        data[61] += ti;
        tr = data[60];
        ti = data[61];
        data[60] = data[56] - tr;
        data[61] = data[57] - ti;
        data[56] += tr;
        data[57] += ti;
        tr = data[62];
        ti = data[63];
        data[62] = data[58] - tr;
        data[63] = data[59] - ti;
        data[58] += tr;
        data[59] += ti;
    }
    // N = 8, at 48
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 56 ] * wr - data[ i + 57 ] * wi;
            uniform float tempi  = data[ i + 56 ] * wi + data[ i + 57 ] * wr;
            uniform float tempr2 = data[ i + 58 ] * wr2 - data[ i + 59 ] * wi2;
            uniform float tempi2 = data[ i + 58 ] * wi2 + data[ i + 59 ] * wr2;
            data[ i + 56 ] = data[ 48 + i ] - tempr;
            data[ i + 57 ] = data[ 49 + i ] - tempi;
            data[ i + 58 ] = data[ 50 + i ] - tempr2;
            data[ i + 59 ] = data[ 51 + i ] - tempi2;
            data[ 48 + i ] += tempr;
            data[ 49 + i ] += tempi;
            data[ 50 + i ] += tempr2;
            data[ 51 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 32
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 48 ] * wr - data[ i + 49 ] * wi;
            uniform float tempi  = data[ i + 48 ] * wi + data[ i + 49 ] * wr;
            uniform float tempr2 = data[ i + 50 ] * wr2 - data[ i + 51 ] * wi2;
            uniform float tempi2 = data[ i + 50 ] * wi2 + data[ i + 51 ] * wr2;
            data[ i + 48 ] = data[ 32 + i ] - tempr;
            data[ i + 49 ] = data[ 33 + i ] - tempi;
            data[ i + 50 ] = data[ 34 + i ] - tempr2;
            data[ i + 51 ] = data[ 35 + i ] - tempi2;
            data[ 32 + i ] += tempr;
            data[ 33 + i ] += tempi;
            data[ 34 + i ] += tempr2;
            data[ 35 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 0
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 32 ] * wr - data[ i + 33 ] * wi;
            uniform float tempi  = data[ i + 32 ] * wi + data[ i + 33 ] * wr;
            uniform float tempr2 = data[ i + 34 ] * wr2 - data[ i + 35 ] * wi2;
            uniform float tempi2 = data[ i + 34 ] * wi2 + data[ i + 35 ] * wr2;
            data[ i + 32 ] = data[ 0 + i ] - tempr;
            data[ i + 33 ] = data[ 1 + i ] - tempi;
            data[ i + 34 ] = data[ 2 + i ] - tempr2;
            data[ i + 35 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 64
    {
        uniform float tr = data[66];
        uniform float ti = data[67];
        data[66] = data[64] - tr;
        data[67] = data[65] - ti;
        data[64] += tr;
        data[65] += ti;
        tr = data[70];
        ti = data[71];
        data[70] = data[69] - ti;
        data[71] = tr - data[68];
        data[68] += tr;
        data[69] += ti;
        tr = data[68];
        ti = data[69];
        data[68] = data[64] - tr;
        data[69] = data[65] - ti;
        data[64] += tr;
        data[65] += ti;
        tr = data[70];
        ti = data[71];
        data[70] = data[66] - tr;
        data[71] = data[67] - ti;
        data[66] += tr;
        data[67] += ti;
    }
    // N = 4, at 72
    {
        uniform float tr = data[74];
        uniform float ti = data[75];
        data[74] = data[72] - tr;
        data[75] = data[73] - ti;
        data[72] += tr;
        data[73] += ti;
        tr = data[78];
        ti = data[79];
        data[78] = data[77] - ti;
        data[79] = tr - data[76];
        data[76] += tr;
        data[77] += ti;
        tr = data[76];
        ti = data[77];
        data[76] = data[72] - tr;
        data[77] = data[73] - ti;
        data[72] += tr;
        data[73] += ti;
        tr = data[78];
        ti = data[79];
        data[78] = data[74] - tr;
        data[79] = data[75] - ti;
        data[74] += tr;
        data[75] += ti;
    }
    // N = 8, at 64
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 72 ] * wr - data[ i + 73 ] * wi;
            uniform float tempi  = data[ i + 72 ] * wi + data[ i + 73 ] * wr;
            uniform float tempr2 = data[ i + 74 ] * wr2 - data[ i + 75 ] * wi2;
            uniform float tempi2 = data[ i + 74 ] * wi2 + data[ i + 75 ] * wr2;
            data[ i + 72 ] = data[ 64 + i ] - tempr;
            data[ i + 73 ] = data[ 65 + i ] - tempi;
            data[ i + 74 ] = data[ 66 + i ] - tempr2;
            data[ i + 75 ] = data[ 67 + i ] - tempi2;
            data[ 64 + i ] += tempr;
            data[ 65 + i ] += tempi;
            data[ 66 + i ] += tempr2;
            data[ 67 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 80
    {
        uniform float tr = data[82];
        uniform float ti = data[83];
        data[82] = data[80] - tr;
        data[83] = data[81] - ti;
        data[80] += tr;
        data[81] += ti;
        tr = data[86];
        ti = data[87];
        data[86] = data[85] - ti;
        data[87] = tr - data[84];
        data[84] += tr;
        data[85] += ti;
        tr = data[84];
        ti = data[85];
        data[84] = data[80] - tr;
        data[85] = data[81] - ti;
        data[80] += tr;
        data[81] += ti;
        tr = data[86];
        ti = data[87];
        data[86] = data[82] - tr;
        data[87] = data[83] - ti;
        data[82] += tr;
        data[83] += ti;
    }
    // N = 4, at 88
    {
        uniform float tr = data[90];
        uniform float ti = data[91];
        data[90] = data[88] - tr;
        data[91] = data[89] - ti;
        data[88] += tr;
        data[89] += ti;
        tr = data[94];
        ti = data[95];
        data[94] = data[93] - ti;
        data[95] = tr - data[92];
        data[92] += tr;
        data[93] += ti;
        tr = data[92];
        ti = data[93];
        data[92] = data[88] - tr;
        data[93] = data[89] - ti;
        data[88] += tr;
        data[89] += ti;
        tr = data[94];
        ti = data[95];
        data[94] = data[90] - tr;
        data[95] = data[91] - ti;
        data[90] += tr;
        data[91] += ti;
    }
    // N = 8, at 80
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 88 ] * wr - data[ i + 89 ] * wi;
            uniform float tempi  = data[ i + 88 ] * wi + data[ i + 89 ] * wr;
            uniform float tempr2 = data[ i + 90 ] * wr2 - data[ i + 91 ] * wi2;
            uniform float tempi2 = data[ i + 90 ] * wi2 + data[ i + 91 ] * wr2;
            data[ i + 88 ] = data[ 80 + i ] - tempr;
            data[ i + 89 ] = data[ 81 + i ] - tempi;
            data[ i + 90 ] = data[ 82 + i ] - tempr2;
            data[ i + 91 ] = data[ 83 + i ] - tempi2;
            data[ 80 + i ] += tempr;
            data[ 81 + i ] += tempi;
            data[ 82 + i ] += tempr2;
            data[ 83 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 64
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 80 ] * wr - data[ i + 81 ] * wi;
            uniform float tempi  = data[ i + 80 ] * wi + data[ i + 81 ] * wr;
            uniform float tempr2 = data[ i + 82 ] * wr2 - data[ i + 83 ] * wi2;
            uniform float tempi2 = data[ i + 82 ] * wi2 + data[ i + 83 ] * wr2;
            data[ i + 80 ] = data[ 64 + i ] - tempr;
            data[ i + 81 ] = data[ 65 + i ] - tempi;
            data[ i + 82 ] = data[ 66 + i ] - tempr2;
            data[ i + 83 ] = data[ 67 + i ] - tempi2;
            data[ 64 + i ] += tempr;
            data[ 65 + i ] += tempi;
            data[ 66 + i ] += tempr2;
            data[ 67 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 96
    {
        uniform float tr = data[98];
        uniform float ti = data[99];
        data[98] = data[96] - tr;
        data[99] = data[97] - ti;
        data[96] += tr;
        data[97] += ti;
        tr = data[102];
        ti = data[103];
        data[102] = data[101] - ti;
        data[103] = tr - data[100];
        data[100] += tr;
        data[101] += ti;
        tr = data[100];
        ti = data[101];
        data[100] = data[96] - tr;
        data[101] = data[97] - ti;
        data[96] += tr;
        data[97] += ti;
        tr = data[102];
        ti = data[103];
        data[102] = data[98] - tr;
        data[103] = data[99] - ti;
        data[98] += tr;
        data[99] += ti;
    }
    // N = 4, at 104
    {
        uniform float tr = data[106];
        uniform float ti = data[107];
        data[106] = data[104] - tr;
        data[107] = data[105] - ti;
        data[104] += tr;
        data[105] += ti;
        tr = data[110];
        ti = data[111];
        data[110] = data[109] - ti;
        data[111] = tr - data[108];
        data[108] += tr;
        data[109] += ti;
        tr = data[108];
        ti = data[109];
        data[108] = data[104] - tr;
        data[109] = data[105] - ti;
        data[104] += tr;
        data[105] += ti;
        tr = data[110];
        ti = data[111];
        data[110] = data[106] - tr;
        data[111] = data[107] - ti;
        data[106] += tr;
        data[107] += ti;
    }
    // N = 8, at 96
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 104 ] * wr - data[ i + 105 ] * wi;
            uniform float tempi  = data[ i + 104 ] * wi + data[ i + 105 ] * wr;
            uniform float tempr2 = data[ i + 106 ] * wr2 - data[ i + 107 ] * wi2;
            uniform float tempi2 = data[ i + 106 ] * wi2 + data[ i + 107 ] * wr2;
            data[ i + 104 ] = data[ 96 + i ] - tempr;
            data[ i + 105 ] = data[ 97 + i ] - tempi;
            data[ i + 106 ] = data[ 98 + i ] - tempr2;
            data[ i + 107 ] = data[ 99 + i ] - tempi2;
            data[ 96 + i ] += tempr;
            data[ 97 + i ] += tempi;
            data[ 98 + i ] += tempr2;
            data[ 99 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 112
    {
        uniform float tr = data[114];
        uniform float ti = data[115];
        data[114] = data[112] - tr;
        data[115] = data[113] - ti;
        data[112] += tr;
        data[113] += ti;
        tr = data[118];
        ti = data[119];
        data[118] = data[117] - ti;
        data[119] = tr - data[116];
        data[116] += tr;
        data[117] += ti;
        tr = data[116];
        ti = data[117];
        data[116] = data[112] - tr;
        data[117] = data[113] - ti;
        data[112] += tr;
        data[113] += ti;
        tr = data[118];
        ti = data[119];
        data[118] = data[114] - tr;
        data[119] = data[115] - ti;
        data[114] += tr;
        data[115] += ti;
    }
    // N = 4, at 120
    {
        uniform float tr = data[122];
        uniform float ti = data[123];
        data[122] = data[120] - tr;
        data[123] = data[121] - ti;
        data[120] += tr;
        data[121] += ti;
        tr = data[126];
        ti = data[127];
        data[126] = data[125] - ti;
        data[127] = tr - data[124];
        data[124] += tr;
        data[125] += ti;
        tr = data[124];
        ti = data[125];
        data[124] = data[120] - tr;
        data[125] = data[121] - ti;
        data[120] += tr;
        data[121] += ti;
        tr = data[126];
        ti = data[127];
        data[126] = data[122] - tr;
        data[127] = data[123] - ti;
        data[122] += tr;
        data[123] += ti;
    }
    // N = 8, at 112
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 120 ] * wr - data[ i + 121 ] * wi;
            uniform float tempi  = data[ i + 120 ] * wi + data[ i + 121 ] * wr;
            uniform float tempr2 = data[ i + 122 ] * wr2 - data[ i + 123 ] * wi2;
            uniform float tempi2 = data[ i + 122 ] * wi2 + data[ i + 123 ] * wr2;
            data[ i + 120 ] = data[ 112 + i ] - tempr;
            data[ i + 121 ] = data[ 113 + i ] - tempi;
            data[ i + 122 ] = data[ 114 + i ] - tempr2;
            data[ i + 123 ] = data[ 115 + i ] - tempi2;
            data[ 112 + i ] += tempr;
            data[ 113 + i ] += tempi;
            data[ 114 + i ] += tempr2;
            data[ 115 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 96
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 112 ] * wr - data[ i + 113 ] * wi;
            uniform float tempi  = data[ i + 112 ] * wi + data[ i + 113 ] * wr;
            uniform float tempr2 = data[ i + 114 ] * wr2 - data[ i + 115 ] * wi2;
            uniform float tempi2 = data[ i + 114 ] * wi2 + data[ i + 115 ] * wr2;
            data[ i + 112 ] = data[ 96 + i ] - tempr;
            data[ i + 113 ] = data[ 97 + i ] - tempi;
            data[ i + 114 ] = data[ 98 + i ] - tempr2;
            data[ i + 115 ] = data[ 99 + i ] - tempi2;
            data[ 96 + i ] += tempr;
            data[ 97 + i ] += tempi;
            data[ 98 + i ] += tempr2;
            data[ 99 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 64
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 96 ] * wr - data[ i + 97 ] * wi;
            uniform float tempi  = data[ i + 96 ] * wi + data[ i + 97 ] * wr;
            uniform float tempr2 = data[ i + 98 ] * wr2 - data[ i + 99 ] * wi2;
            uniform float tempi2 = data[ i + 98 ] * wi2 + data[ i + 99 ] * wr2;
            data[ i + 96 ] = data[ 64 + i ] - tempr;
            data[ i + 97 ] = data[ 65 + i ] - tempi;
            data[ i + 98 ] = data[ 66 + i ] - tempr2;
            data[ i + 99 ] = data[ 67 + i ] - tempi2;
            data[ 64 + i ] += tempr;
            data[ 65 + i ] += tempi;
            data[ 66 + i ] += tempr2;
            data[ 67 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 0
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 64 ] * wr - data[ i + 65 ] * wi;
            uniform float tempi  = data[ i + 64 ] * wi + data[ i + 65 ] * wr;
            uniform float tempr2 = data[ i + 66 ] * wr2 - data[ i + 67 ] * wi2;
            uniform float tempi2 = data[ i + 66 ] * wi2 + data[ i + 67 ] * wr2;
            data[ i + 64 ] = data[ 0 + i ] - tempr;
            data[ i + 65 ] = data[ 1 + i ] - tempi;
            data[ i + 66 ] = data[ 2 + i ] - tempr2;
            data[ i + 67 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 128
    {
        uniform float tr = data[130];
        uniform float ti = data[131];
        data[130] = data[128] - tr;
        data[131] = data[129] - ti;
        data[128] += tr;
        data[129] += ti;
        tr = data[134];
        ti = data[135];
        data[134] = data[133] - ti;
        data[135] = tr - data[132];
        data[132] += tr;
        data[133] += ti;
        tr = data[132];
        ti = data[133];
        data[132] = data[128] - tr;
        data[133] = data[129] - ti;
        data[128] += tr;
        data[129] += ti;
        tr = data[134];
        ti = data[135];
        data[134] = data[130] - tr;
        data[135] = data[131] - ti;
        data[130] += tr;
        data[131] += ti;
    }
    // N = 4, at 136
    {
        uniform float tr = data[138];
        uniform float ti = data[139];
        data[138] = data[136] - tr;
        data[139] = data[137] - ti;
        data[136] += tr;
        data[137] += ti;
        tr = data[142];
        ti = data[143];
        data[142] = data[141] - ti;
        data[143] = tr - data[140];
        data[140] += tr;
        data[141] += ti;
        tr = data[140];
        ti = data[141];
        data[140] = data[136] - tr;
        data[141] = data[137] - ti;
        data[136] += tr;
        data[137] += ti;
        tr = data[142];
        ti = data[143];
        data[142] = data[138] - tr;
        data[143] = data[139] - ti;
        data[138] += tr;
        data[139] += ti;
    }
    // N = 8, at 128
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 136 ] * wr - data[ i + 137 ] * wi;
            uniform float tempi  = data[ i + 136 ] * wi + data[ i + 137 ] * wr;
            uniform float tempr2 = data[ i + 138 ] * wr2 - data[ i + 139 ] * wi2;
            uniform float tempi2 = data[ i + 138 ] * wi2 + data[ i + 139 ] * wr2;
            data[ i + 136 ] = data[ 128 + i ] - tempr;
            data[ i + 137 ] = data[ 129 + i ] - tempi;
            data[ i + 138 ] = data[ 130 + i ] - tempr2;
            data[ i + 139 ] = data[ 131 + i ] - tempi2;
            data[ 128 + i ] += tempr;
            data[ 129 + i ] += tempi;
            data[ 130 + i ] += tempr2;
            data[ 131 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 144
    {
        uniform float tr = data[146];
        uniform float ti = data[147];
        data[146] = data[144] - tr;
        data[147] = data[145] - ti;
        data[144] += tr;
        data[145] += ti;
        tr = data[150];
        ti = data[151];
        data[150] = data[149] - ti;
        data[151] = tr - data[148];
        data[148] += tr;
        data[149] += ti;
        tr = data[148];
        ti = data[149];
        data[148] = data[144] - tr;
        data[149] = data[145] - ti;
        data[144] += tr;
        data[145] += ti;
        tr = data[150];
        ti = data[151];
        data[150] = data[146] - tr;
        data[151] = data[147] - ti;
        data[146] += tr;
        data[147] += ti;
    }
    // N = 4, at 152
    {
        uniform float tr = data[154];
        uniform float ti = data[155];
        data[154] = data[152] - tr;
        data[155] = data[153] - ti;
        data[152] += tr;
        data[153] += ti;
        tr = data[158];
        ti = data[159];
        data[158] = data[157] - ti;
        data[159] = tr - data[156];
        data[156] += tr;
        data[157] += ti;
        tr = data[156];
        ti = data[157];
        data[156] = data[152] - tr;
        data[157] = data[153] - ti;
        data[152] += tr;
        data[153] += ti;
        tr = data[158];
        ti = data[159];
        data[158] = data[154] - tr;
        data[159] = data[155] - ti;
        data[154] += tr;
        data[155] += ti;
    }
    // N = 8, at 144
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 152 ] * wr - data[ i + 153 ] * wi;
            uniform float tempi  = data[ i + 152 ] * wi + data[ i + 153 ] * wr;
            uniform float tempr2 = data[ i + 154 ] * wr2 - data[ i + 155 ] * wi2;
            uniform float tempi2 = data[ i + 154 ] * wi2 + data[ i + 155 ] * wr2;
            data[ i + 152 ] = data[ 144 + i ] - tempr;
            data[ i + 153 ] = data[ 145 + i ] - tempi;
            data[ i + 154 ] = data[ 146 + i ] - tempr2;
            data[ i + 155 ] = data[ 147 + i ] - tempi2;
            data[ 144 + i ] += tempr;
            data[ 145 + i ] += tempi;
            data[ 146 + i ] += tempr2;
            data[ 147 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 128
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 144 ] * wr - data[ i + 145 ] * wi;
            uniform float tempi  = data[ i + 144 ] * wi + data[ i + 145 ] * wr;
            uniform float tempr2 = data[ i + 146 ] * wr2 - data[ i + 147 ] * wi2;
            uniform float tempi2 = data[ i + 146 ] * wi2 + data[ i + 147 ] * wr2;
            data[ i + 144 ] = data[ 128 + i ] - tempr;
            data[ i + 145 ] = data[ 129 + i ] - tempi;
            data[ i + 146 ] = data[ 130 + i ] - tempr2;
            data[ i + 147 ] = data[ 131 + i ] - tempi2;
            data[ 128 + i ] += tempr;
            data[ 129 + i ] += tempi;
            data[ 130 + i ] += tempr2;
            data[ 131 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 160
    {
        uniform float tr = data[162];
        uniform float ti = data[163];
        data[162] = data[160] - tr;
        data[163] = data[161] - ti;
        data[160] += tr;
        data[161] += ti;
        tr = data[166];
        ti = data[167];
        data[166] = data[165] - ti;
        data[167] = tr - data[164];
        data[164] += tr;
        data[165] += ti;
        tr = data[164];
        ti = data[165];
        data[164] = data[160] - tr;
        data[165] = data[161] - ti;
        data[160] += tr;
        data[161] += ti;
        tr = data[166];
        ti = data[167];
        data[166] = data[162] - tr;
        data[167] = data[163] - ti;
        data[162] += tr;
        data[163] += ti;
    }
    // N = 4, at 168
    {
        uniform float tr = data[170];
        uniform float ti = data[171];
        data[170] = data[168] - tr;
        data[171] = data[169] - ti;
        data[168] += tr;
        data[169] += ti;
        tr = data[174];
        ti = data[175];
        data[174] = data[173] - ti;
        data[175] = tr - data[172];
        data[172] += tr;
        data[173] += ti;
        tr = data[172];
        ti = data[173];
        data[172] = data[168] - tr;
        data[173] = data[169] - ti;
        data[168] += tr;
        data[169] += ti;
        tr = data[174];
        ti = data[175];
        data[174] = data[170] - tr;
        data[175] = data[171] - ti;
        data[170] += tr;
        data[171] += ti;
    }
    // N = 8, at 160
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 168 ] * wr - data[ i + 169 ] * wi;
            uniform float tempi  = data[ i + 168 ] * wi + data[ i + 169 ] * wr;
            uniform float tempr2 = data[ i + 170 ] * wr2 - data[ i + 171 ] * wi2;
            uniform float tempi2 = data[ i + 170 ] * wi2 + data[ i + 171 ] * wr2;
            data[ i + 168 ] = data[ 160 + i ] - tempr;
            data[ i + 169 ] = data[ 161 + i ] - tempi;
            data[ i + 170 ] = data[ 162 + i ] - tempr2;
            data[ i + 171 ] = data[ 163 + i ] - tempi2;
            data[ 160 + i ] += tempr;
            data[ 161 + i ] += tempi;
            data[ 162 + i ] += tempr2;
            data[ 163 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 176
    {
        uniform float tr = data[178];
        uniform float ti = data[179];
        data[178] = data[176] - tr;
        data[179] = data[177] - ti;
        data[176] += tr;
        data[177] += ti;
        tr = data[182];
        ti = data[183];
        data[182] = data[181] - ti;
        data[183] = tr - data[180];
        data[180] += tr;
        data[181] += ti;
        tr = data[180];
        ti = data[181];
        data[180] = data[176] - tr;
        data[181] = data[177] - ti;
        data[176] += tr;
        data[177] += ti;
        tr = data[182];
        ti = data[183];
        data[182] = data[178] - tr;
        data[183] = data[179] - ti;
        data[178] += tr;
        data[179] += ti;
    }
    // N = 4, at 184
    {
        uniform float tr = data[186];
        uniform float ti = data[187];
        data[186] = data[184] - tr;
        data[187] = data[185] - ti;
        data[184] += tr;
        data[185] += ti;
        tr = data[190];
        ti = data[191];
        data[190] = data[189] - ti;
        data[191] = tr - data[188];
        data[188] += tr;
        data[189] += ti;
        tr = data[188];
        ti = data[189];
        data[188] = data[184] - tr;
        data[189] = data[185] - ti;
        data[184] += tr;
        data[185] += ti;
        tr = data[190];
        ti = data[191];
        data[190] = data[186] - tr;
        data[191] = data[187] - ti;
        data[186] += tr;
        data[187] += ti;
    }
    // N = 8, at 176
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 184 ] * wr - data[ i + 185 ] * wi;
            uniform float tempi  = data[ i + 184 ] * wi + data[ i + 185 ] * wr;
            uniform float tempr2 = data[ i + 186 ] * wr2 - data[ i + 187 ] * wi2;
            uniform float tempi2 = data[ i + 186 ] * wi2 + data[ i + 187 ] * wr2;
            data[ i + 184 ] = data[ 176 + i ] - tempr;
            data[ i + 185 ] = data[ 177 + i ] - tempi;
            data[ i + 186 ] = data[ 178 + i ] - tempr2;
            data[ i + 187 ] = data[ 179 + i ] - tempi2;
            data[ 176 + i ] += tempr;
            data[ 177 + i ] += tempi;
            data[ 178 + i ] += tempr2;
            data[ 179 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 160
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 176 ] * wr - data[ i + 177 ] * wi;
            uniform float tempi  = data[ i + 176 ] * wi + data[ i + 177 ] * wr;
            uniform float tempr2 = data[ i + 178 ] * wr2 - data[ i + 179 ] * wi2;
            uniform float tempi2 = data[ i + 178 ] * wi2 + data[ i + 179 ] * wr2;
            data[ i + 176 ] = data[ 160 + i ] - tempr;
            data[ i + 177 ] = data[ 161 + i ] - tempi;
            data[ i + 178 ] = data[ 162 + i ] - tempr2;
            data[ i + 179 ] = data[ 163 + i ] - tempi2;
            data[ 160 + i ] += tempr;
            data[ 161 + i ] += tempi;
            data[ 162 + i ] += tempr2;
            data[ 163 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 128
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 160 ] * wr - data[ i + 161 ] * wi;
            uniform float tempi  = data[ i + 160 ] * wi + data[ i + 161 ] * wr;
            uniform float tempr2 = data[ i + 162 ] * wr2 - data[ i + 163 ] * wi2;
            uniform float tempi2 = data[ i + 162 ] * wi2 + data[ i + 163 ] * wr2;
            data[ i + 160 ] = data[ 128 + i ] - tempr;
            data[ i + 161 ] = data[ 129 + i ] - tempi;
            data[ i + 162 ] = data[ 130 + i ] - tempr2;
            data[ i + 163 ] = data[ 131 + i ] - tempi2;
            data[ 128 + i ] += tempr;
            data[ 129 + i ] += tempi;
            data[ 130 + i ] += tempr2;
            data[ 131 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 192
    {
        uniform float tr = data[194];
        uniform float ti = data[195];
        data[194] = data[192] - tr;
        data[195] = data[193] - ti;
        data[192] += tr;
        data[193] += ti;
        tr = data[198];
        ti = data[199];
        data[198] = data[197] - ti;
        data[199] = tr - data[196];
        data[196] += tr;
        data[197] += ti;
        tr = data[196];
        ti = data[197];
        data[196] = data[192] - tr;
        data[197] = data[193] - ti;
        data[192] += tr;
        data[193] += ti;
        tr = data[198];
        ti = data[199];
        data[198] = data[194] - tr;
        data[199] = data[195] - ti;
        data[194] += tr;
        data[195] += ti;
    }
    // N = 4, at 200
    {
        uniform float tr = data[202];
        uniform float ti = data[203];
        data[202] = data[200] - tr;
        data[203] = data[201] - ti;
        data[200] += tr;
        data[201] += ti;
        tr = data[206];
        ti = data[207];
        data[206] = data[205] - ti;
        data[207] = tr - data[204];
        data[204] += tr;
        data[205] += ti;
        tr = data[204];
        ti = data[205];
        data[204] = data[200] - tr;
        data[205] = data[201] - ti;
        data[200] += tr;
        data[201] += ti;
        tr = data[206];
        ti = data[207];
        data[206] = data[202] - tr;
        data[207] = data[203] - ti;
        data[202] += tr;
        data[203] += ti;
    }
    // N = 8, at 192
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 200 ] * wr - data[ i + 201 ] * wi;
            uniform float tempi  = data[ i + 200 ] * wi + data[ i + 201 ] * wr;
            uniform float tempr2 = data[ i + 202 ] * wr2 - data[ i + 203 ] * wi2;
            uniform float tempi2 = data[ i + 202 ] * wi2 + data[ i + 203 ] * wr2;
            data[ i + 200 ] = data[ 192 + i ] - tempr;
            data[ i + 201 ] = data[ 193 + i ] - tempi;
            data[ i + 202 ] = data[ 194 + i ] - tempr2;
            data[ i + 203 ] = data[ 195 + i ] - tempi2;
            data[ 192 + i ] += tempr;
            data[ 193 + i ] += tempi;
            data[ 194 + i ] += tempr2;
            data[ 195 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 208
    {
        uniform float tr = data[210];
        uniform float ti = data[211];
        data[210] = data[208] - tr;
        data[211] = data[209] - ti;
        data[208] += tr;
        data[209] += ti;
        tr = data[214];
        ti = data[215];
        data[214] = data[213] - ti;
        data[215] = tr - data[212];
        data[212] += tr;
        data[213] += ti;
        tr = data[212];
        ti = data[213];
        data[212] = data[208] - tr;
        data[213] = data[209] - ti;
        data[208] += tr;
        data[209] += ti;
        tr = data[214];
        ti = data[215];
        data[214] = data[210] - tr;
        data[215] = data[211] - ti;
        data[210] += tr;
        data[211] += ti;
    }
    // N = 4, at 216
    {
        uniform float tr = data[218];
        uniform float ti = data[219];
        data[218] = data[216] - tr;
        data[219] = data[217] - ti;
        data[216] += tr;
        data[217] += ti;
        tr = data[222];
        ti = data[223];
        data[222] = data[221] - ti;
        data[223] = tr - data[220];
        data[220] += tr;
        data[221] += ti;
        tr = data[220];
        ti = data[221];
        data[220] = data[216] - tr;
        data[221] = data[217] - ti;
        data[216] += tr;
        data[217] += ti;
        tr = data[222];
        ti = data[223];
        data[222] = data[218] - tr;
        data[223] = data[219] - ti;
        data[218] += tr;
        data[219] += ti;
    }
    // N = 8, at 208
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 216 ] * wr - data[ i + 217 ] * wi;
            uniform float tempi  = data[ i + 216 ] * wi + data[ i + 217 ] * wr;
            uniform float tempr2 = data[ i + 218 ] * wr2 - data[ i + 219 ] * wi2;
            uniform float tempi2 = data[ i + 218 ] * wi2 + data[ i + 219 ] * wr2;
            data[ i + 216 ] = data[ 208 + i ] - tempr;
            data[ i + 217 ] = data[ 209 + i ] - tempi;
            data[ i + 218 ] = data[ 210 + i ] - tempr2;
            data[ i + 219 ] = data[ 211 + i ] - tempi2;
            data[ 208 + i ] += tempr;
            data[ 209 + i ] += tempi;
            data[ 210 + i ] += tempr2;
            data[ 211 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 192
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 208 ] * wr - data[ i + 209 ] * wi;
            uniform float tempi  = data[ i + 208 ] * wi + data[ i + 209 ] * wr;
            uniform float tempr2 = data[ i + 210 ] * wr2 - data[ i + 211 ] * wi2;
            uniform float tempi2 = data[ i + 210 ] * wi2 + data[ i + 211 ] * wr2;
            data[ i + 208 ] = data[ 192 + i ] - tempr;
            data[ i + 209 ] = data[ 193 + i ] - tempi;
            data[ i + 210 ] = data[ 194 + i ] - tempr2;
            data[ i + 211 ] = data[ 195 + i ] - tempi2;
            data[ 192 + i ] += tempr;
            data[ 193 + i ] += tempi;
            data[ 194 + i ] += tempr2;
            data[ 195 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 224
    {
        uniform float tr = data[226];
        uniform float ti = data[227];
        data[226] = data[224] - tr;
        data[227] = data[225] - ti;
        data[224] += tr;
        data[225] += ti;
        tr = data[230];
        ti = data[231];
        data[230] = data[229] - ti;
        data[231] = tr - data[228];
        data[228] += tr;
        data[229] += ti;
        tr = data[228];
        ti = data[229];
        data[228] = data[224] - tr;
        data[229] = data[225] - ti;
        data[224] += tr;
        data[225] += ti;
        tr = data[230];
        ti = data[231];
        data[230] = data[226] - tr;
        data[231] = data[227] - ti;
        data[226] += tr;
        data[227] += ti;
    }
    // N = 4, at 232
    {
        uniform float tr = data[234];
        uniform float ti = data[235];
        data[234] = data[232] - tr;
        data[235] = data[233] - ti;
        data[232] += tr;
        data[233] += ti;
        tr = data[238];
        ti = data[239];
        data[238] = data[237] - ti;
        data[239] = tr - data[236];
        data[236] += tr;
        data[237] += ti;
        tr = data[236];
        ti = data[237];
        data[236] = data[232] - tr;
        data[237] = data[233] - ti;
        data[232] += tr;
        data[233] += ti;
        tr = data[238];
        ti = data[239];
        data[238] = data[234] - tr;
        data[239] = data[235] - ti;
        data[234] += tr;
        data[235] += ti;
    }
    // N = 8, at 224
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 232 ] * wr - data[ i + 233 ] * wi;
            uniform float tempi  = data[ i + 232 ] * wi + data[ i + 233 ] * wr;
            uniform float tempr2 = data[ i + 234 ] * wr2 - data[ i + 235 ] * wi2;
            uniform float tempi2 = data[ i + 234 ] * wi2 + data[ i + 235 ] * wr2;
            data[ i + 232 ] = data[ 224 + i ] - tempr;
            data[ i + 233 ] = data[ 225 + i ] - tempi;
            data[ i + 234 ] = data[ 226 + i ] - tempr2;
            data[ i + 235 ] = data[ 227 + i ] - tempi2;
            data[ 224 + i ] += tempr;
            data[ 225 + i ] += tempi;
            data[ 226 + i ] += tempr2;
            data[ 227 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 240
    {
        uniform float tr = data[242];
        uniform float ti = data[243];
        data[242] = data[240] - tr;
        data[243] = data[241] - ti;
        data[240] += tr;
        data[241] += ti;
        tr = data[246];
        ti = data[247];
        data[246] = data[245] - ti;
        data[247] = tr - data[244];
        data[244] += tr;
        data[245] += ti;
        tr = data[244];
        ti = data[245];
        data[244] = data[240] - tr;
        data[245] = data[241] - ti;
        data[240] += tr;
        data[241] += ti;
        tr = data[246];
        ti = data[247];
        data[246] = data[242] - tr;
        data[247] = data[243] - ti;
        data[242] += tr;
        data[243] += ti;
    }
    // N = 4, at 248
    {
        uniform float tr = data[250];
        uniform float ti = data[251];
        data[250] = data[248] - tr;
        data[251] = data[249] - ti;
        data[248] += tr;
        data[249] += ti;
        tr = data[254];
        ti = data[255];
        data[254] = data[253] - ti;
        data[255] = tr - data[252];
        data[252] += tr;
        data[253] += ti;
        tr = data[252];
        ti = data[253];
        data[252] = data[248] - tr;
        data[253] = data[249] - ti;
        data[248] += tr;
        data[249] += ti;
        tr = data[254];
        ti = data[255];
        data[254] = data[250] - tr;
        data[255] = data[251] - ti;
        data[250] += tr;
        data[251] += ti;
    }
    // N = 8, at 240
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 248 ] * wr - data[ i + 249 ] * wi;
            uniform float tempi  = data[ i + 248 ] * wi + data[ i + 249 ] * wr;
            uniform float tempr2 = data[ i + 250 ] * wr2 - data[ i + 251 ] * wi2;
            uniform float tempi2 = data[ i + 250 ] * wi2 + data[ i + 251 ] * wr2;
            data[ i + 248 ] = data[ 240 + i ] - tempr;
            data[ i + 249 ] = data[ 241 + i ] - tempi;
            data[ i + 250 ] = data[ 242 + i ] - tempr2;
            data[ i + 251 ] = data[ 243 + i ] - tempi2;
            data[ 240 + i ] += tempr;
            data[ 241 + i ] += tempi;
            data[ 242 + i ] += tempr2;
            data[ 243 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 224
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 240 ] * wr - data[ i + 241 ] * wi;
            uniform float tempi  = data[ i + 240 ] * wi + data[ i + 241 ] * wr;
            uniform float tempr2 = data[ i + 242 ] * wr2 - data[ i + 243 ] * wi2;
            uniform float tempi2 = data[ i + 242 ] * wi2 + data[ i + 243 ] * wr2;
            data[ i + 240 ] = data[ 224 + i ] - tempr;
            data[ i + 241 ] = data[ 225 + i ] - tempi;
            data[ i + 242 ] = data[ 226 + i ] - tempr2;
            data[ i + 243 ] = data[ 227 + i ] - tempi2;
            data[ 224 + i ] += tempr;
            data[ 225 + i ] += tempi;
            data[ 226 + i ] += tempr2;
            data[ 227 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 192
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 224 ] * wr - data[ i + 225 ] * wi;
            uniform float tempi  = data[ i + 224 ] * wi + data[ i + 225 ] * wr;
            uniform float tempr2 = data[ i + 226 ] * wr2 - data[ i + 227 ] * wi2;
            uniform float tempi2 = data[ i + 226 ] * wi2 + data[ i + 227 ] * wr2;
            data[ i + 224 ] = data[ 192 + i ] - tempr;
            data[ i + 225 ] = data[ 193 + i ] - tempi;
            data[ i + 226 ] = data[ 194 + i ] - tempr2;
            data[ i + 227 ] = data[ 195 + i ] - tempi2;
            data[ 192 + i ] += tempr;
            data[ 193 + i ] += tempi;
            data[ 194 + i ] += tempr2;
            data[ 195 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 128
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 192 ] * wr - data[ i + 193 ] * wi;
            uniform float tempi  = data[ i + 192 ] * wi + data[ i + 193 ] * wr;
            uniform float tempr2 = data[ i + 194 ] * wr2 - data[ i + 195 ] * wi2;
            uniform float tempi2 = data[ i + 194 ] * wi2 + data[ i + 195 ] * wr2;
            data[ i + 192 ] = data[ 128 + i ] - tempr;
            data[ i + 193 ] = data[ 129 + i ] - tempi;
            data[ i + 194 ] = data[ 130 + i ] - tempr2;
            data[ i + 195 ] = data[ 131 + i ] - tempi2;
            data[ 128 + i ] += tempr;
            data[ 129 + i ] += tempi;
            data[ 130 + i ] += tempr2;
            data[ 131 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 0
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 128 ] * wr - data[ i + 129 ] * wi;
            uniform float tempi  = data[ i + 128 ] * wi + data[ i + 129 ] * wr;
            uniform float tempr2 = data[ i + 130 ] * wr2 - data[ i + 131 ] * wi2;
            uniform float tempi2 = data[ i + 130 ] * wi2 + data[ i + 131 ] * wr2;
            data[ i + 128 ] = data[ 0 + i ] - tempr;
            data[ i + 129 ] = data[ 1 + i ] - tempi;
            data[ i + 130 ] = data[ 2 + i ] - tempr2;
            data[ i + 131 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 256
    {
        uniform float tr = data[258];
        uniform float ti = data[259];
        data[258] = data[256] - tr;
        data[259] = data[257] - ti;
        data[256] += tr;
        data[257] += ti;
        tr = data[262];
        ti = data[263];
        data[262] = data[261] - ti;
        data[263] = tr - data[260];
        data[260] += tr;
        data[261] += ti;
        tr = data[260];
        ti = data[261];
        data[260] = data[256] - tr;
        data[261] = data[257] - ti;
        data[256] += tr;
        data[257] += ti;
        tr = data[262];
        ti = data[263];
        data[262] = data[258] - tr;
        data[263] = data[259] - ti;
        data[258] += tr;
        data[259] += ti;
    }
    // N = 4, at 264
    {
        uniform float tr = data[266];
        uniform float ti = data[267];
        data[266] = data[264] - tr;
        data[267] = data[265] - ti;
        data[264] += tr;
        data[265] += ti;
        tr = data[270];
        ti = data[271];
        data[270] = data[269] - ti;
        data[271] = tr - data[268];
        data[268] += tr;
        data[269] += ti;
        tr = data[268];
        ti = data[269];
        data[268] = data[264] - tr;
        data[269] = data[265] - ti;
        data[264] += tr;
        data[265] += ti;
        tr = data[270];
        ti = data[271];
        data[270] = data[266] - tr;
        data[271] = data[267] - ti;
        data[266] += tr;
        data[267] += ti;
    }
    // N = 8, at 256
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 264 ] * wr - data[ i + 265 ] * wi;
            uniform float tempi  = data[ i + 264 ] * wi + data[ i + 265 ] * wr;
            uniform float tempr2 = data[ i + 266 ] * wr2 - data[ i + 267 ] * wi2;
            uniform float tempi2 = data[ i + 266 ] * wi2 + data[ i + 267 ] * wr2;
            data[ i + 264 ] = data[ 256 + i ] - tempr;
            data[ i + 265 ] = data[ 257 + i ] - tempi;
            data[ i + 266 ] = data[ 258 + i ] - tempr2;
            data[ i + 267 ] = data[ 259 + i ] - tempi2;
            data[ 256 + i ] += tempr;
            data[ 257 + i ] += tempi;
            data[ 258 + i ] += tempr2;
            data[ 259 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 272
    {
        uniform float tr = data[274];
        uniform float ti = data[275];
        data[274] = data[272] - tr;
        data[275] = data[273] - ti;
        data[272] += tr;
        data[273] += ti;
        tr = data[278];
        ti = data[279];
        data[278] = data[277] - ti;
        data[279] = tr - data[276];
        data[276] += tr;
        data[277] += ti;
        tr = data[276];
        ti = data[277];
        data[276] = data[272] - tr;
        data[277] = data[273] - ti;
        data[272] += tr;
        data[273] += ti;
        tr = data[278];
        ti = data[279];
        data[278] = data[274] - tr;
        data[279] = data[275] - ti;
        data[274] += tr;
        data[275] += ti;
    }
    // N = 4, at 280
    {
        uniform float tr = data[282];
        uniform float ti = data[283];
        data[282] = data[280] - tr;
        data[283] = data[281] - ti;
        data[280] += tr;
        data[281] += ti;
        tr = data[286];
        ti = data[287];
        data[286] = data[285] - ti;
        data[287] = tr - data[284];
        data[284] += tr;
        data[285] += ti;
        tr = data[284];
        ti = data[285];
        data[284] = data[280] - tr;
        data[285] = data[281] - ti;
        data[280] += tr;
        data[281] += ti;
        tr = data[286];
        ti = data[287];
        data[286] = data[282] - tr;
        data[287] = data[283] - ti;
        data[282] += tr;
        data[283] += ti;
    }
    // N = 8, at 272
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 280 ] * wr - data[ i + 281 ] * wi;
            uniform float tempi  = data[ i + 280 ] * wi + data[ i + 281 ] * wr;
            uniform float tempr2 = data[ i + 282 ] * wr2 - data[ i + 283 ] * wi2;
            uniform float tempi2 = data[ i + 282 ] * wi2 + data[ i + 283 ] * wr2;
            data[ i + 280 ] = data[ 272 + i ] - tempr;
            data[ i + 281 ] = data[ 273 + i ] - tempi;
            data[ i + 282 ] = data[ 274 + i ] - tempr2;
            data[ i + 283 ] = data[ 275 + i ] - tempi2;
            data[ 272 + i ] += tempr;
            data[ 273 + i ] += tempi;
            data[ 274 + i ] += tempr2;
            data[ 275 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 256
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 272 ] * wr - data[ i + 273 ] * wi;
            uniform float tempi  = data[ i + 272 ] * wi + data[ i + 273 ] * wr;
            uniform float tempr2 = data[ i + 274 ] * wr2 - data[ i + 275 ] * wi2;
            uniform float tempi2 = data[ i + 274 ] * wi2 + data[ i + 275 ] * wr2;
            data[ i + 272 ] = data[ 256 + i ] - tempr;
            data[ i + 273 ] = data[ 257 + i ] - tempi;
            data[ i + 274 ] = data[ 258 + i ] - tempr2;
            data[ i + 275 ] = data[ 259 + i ] - tempi2;
            data[ 256 + i ] += tempr;
            data[ 257 + i ] += tempi;
            data[ 258 + i ] += tempr2;
            data[ 259 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 288
    {
        uniform float tr = data[290];
        uniform float ti = data[291];
        data[290] = data[288] - tr;
        data[291] = data[289] - ti;
        data[288] += tr;
        data[289] += ti;
        tr = data[294];
        ti = data[295];
        data[294] = data[293] - ti;
        data[295] = tr - data[292];
        data[292] += tr;
        data[293] += ti;
        tr = data[292];
        ti = data[293];
        data[292] = data[288] - tr;
        data[293] = data[289] - ti;
        data[288] += tr;
        data[289] += ti;
        tr = data[294];
        ti = data[295];
        data[294] = data[290] - tr;
        data[295] = data[291] - ti;
        data[290] += tr;
        data[291] += ti;
    }
    // N = 4, at 296
    {
        uniform float tr = data[298];
        uniform float ti = data[299];
        data[298] = data[296] - tr;
        data[299] = data[297] - ti;
        data[296] += tr;
        data[297] += ti;
        tr = data[302];
        ti = data[303];
        data[302] = data[301] - ti;
        data[303] = tr - data[300];
        data[300] += tr;
        data[301] += ti;
        tr = data[300];
        ti = data[301];
        data[300] = data[296] - tr;
        data[301] = data[297] - ti;
        data[296] += tr;
        data[297] += ti;
        tr = data[302];
        ti = data[303];
        data[302] = data[298] - tr;
        data[303] = data[299] - ti;
        data[298] += tr;
        data[299] += ti;
    }
    // N = 8, at 288
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 296 ] * wr - data[ i + 297 ] * wi;
            uniform float tempi  = data[ i + 296 ] * wi + data[ i + 297 ] * wr;
            uniform float tempr2 = data[ i + 298 ] * wr2 - data[ i + 299 ] * wi2;
            uniform float tempi2 = data[ i + 298 ] * wi2 + data[ i + 299 ] * wr2;
            data[ i + 296 ] = data[ 288 + i ] - tempr;
            data[ i + 297 ] = data[ 289 + i ] - tempi;
            data[ i + 298 ] = data[ 290 + i ] - tempr2;
            data[ i + 299 ] = data[ 291 + i ] - tempi2;
            data[ 288 + i ] += tempr;
            data[ 289 + i ] += tempi;
            data[ 290 + i ] += tempr2;
            data[ 291 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 304
    {
        uniform float tr = data[306];
        uniform float ti = data[307];
        data[306] = data[304] - tr;
        data[307] = data[305] - ti;
        data[304] += tr;
        data[305] += ti;
        tr = data[310];
        ti = data[311];
        data[310] = data[309] - ti;
        data[311] = tr - data[308];
        data[308] += tr;
        data[309] += ti;
        tr = data[308];
        ti = data[309];
        data[308] = data[304] - tr;
        data[309] = data[305] - ti;
        data[304] += tr;
        data[305] += ti;
        tr = data[310];
        ti = data[311];
        data[310] = data[306] - tr;
        data[311] = data[307] - ti;
        data[306] += tr;
        data[307] += ti;
    }
    // N = 4, at 312
    {
        uniform float tr = data[314];
        uniform float ti = data[315];
        data[314] = data[312] - tr;
        data[315] = data[313] - ti;
        data[312] += tr;
        data[313] += ti;
        tr = data[318];
        ti = data[319];
        data[318] = data[317] - ti;
        data[319] = tr - data[316];
        data[316] += tr;
        data[317] += ti;
        tr = data[316];
        ti = data[317];
        data[316] = data[312] - tr;
        data[317] = data[313] - ti;
        data[312] += tr;
        data[313] += ti;
        tr = data[318];
        ti = data[319];
        data[318] = data[314] - tr;
        data[319] = data[315] - ti;
        data[314] += tr;
        data[315] += ti;
    }
    // N = 8, at 304
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 312 ] * wr - data[ i + 313 ] * wi;
            uniform float tempi  = data[ i + 312 ] * wi + data[ i + 313 ] * wr;
            uniform float tempr2 = data[ i + 314 ] * wr2 - data[ i + 315 ] * wi2;
            uniform float tempi2 = data[ i + 314 ] * wi2 + data[ i + 315 ] * wr2;
            data[ i + 312 ] = data[ 304 + i ] - tempr;
            data[ i + 313 ] = data[ 305 + i ] - tempi;
            data[ i + 314 ] = data[ 306 + i ] - tempr2;
            data[ i + 315 ] = data[ 307 + i ] - tempi2;
            data[ 304 + i ] += tempr;
            data[ 305 + i ] += tempi;
            data[ 306 + i ] += tempr2;
            data[ 307 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 288
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 304 ] * wr - data[ i + 305 ] * wi;
            uniform float tempi  = data[ i + 304 ] * wi + data[ i + 305 ] * wr;
            uniform float tempr2 = data[ i + 306 ] * wr2 - data[ i + 307 ] * wi2;
            uniform float tempi2 = data[ i + 306 ] * wi2 + data[ i + 307 ] * wr2;
            data[ i + 304 ] = data[ 288 + i ] - tempr;
            data[ i + 305 ] = data[ 289 + i ] - tempi;
            data[ i + 306 ] = data[ 290 + i ] - tempr2;
            data[ i + 307 ] = data[ 291 + i ] - tempi2;
            data[ 288 + i ] += tempr;
            data[ 289 + i ] += tempi;
            data[ 290 + i ] += tempr2;
            data[ 291 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 256
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 288 ] * wr - data[ i + 289 ] * wi;
            uniform float tempi  = data[ i + 288 ] * wi + data[ i + 289 ] * wr;
            uniform float tempr2 = data[ i + 290 ] * wr2 - data[ i + 291 ] * wi2;
            uniform float tempi2 = data[ i + 290 ] * wi2 + data[ i + 291 ] * wr2;
            data[ i + 288 ] = data[ 256 + i ] - tempr;
            data[ i + 289 ] = data[ 257 + i ] - tempi;
            data[ i + 290 ] = data[ 258 + i ] - tempr2;
            data[ i + 291 ] = data[ 259 + i ] - tempi2;
            data[ 256 + i ] += tempr;
            data[ 257 + i ] += tempi;
            data[ 258 + i ] += tempr2;
            data[ 259 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 320
    {
        uniform float tr = data[322];
        uniform float ti = data[323];
        data[322] = data[320] - tr;
        data[323] = data[321] - ti;
        data[320] += tr;
        data[321] += ti;
        tr = data[326];
        ti = data[327];
        data[326] = data[325] - ti;
        data[327] = tr - data[324];
        data[324] += tr;
        data[325] += ti;
        tr = data[324];
        ti = data[325];
        data[324] = data[320] - tr;
        data[325] = data[321] - ti;
        data[320] += tr;
        data[321] += ti;
        tr = data[326];
        ti = data[327];
        data[326] = data[322] - tr;
        data[327] = data[323] - ti;
        data[322] += tr;
        data[323] += ti;
    }
    // N = 4, at 328
    {
        uniform float tr = data[330];
        uniform float ti = data[331];
        data[330] = data[328] - tr;
        data[331] = data[329] - ti;
        data[328] += tr;
        data[329] += ti;
        tr = data[334];
        ti = data[335];
        data[334] = data[333] - ti;
        data[335] = tr - data[332];
        data[332] += tr;
        data[333] += ti;
        tr = data[332];
        ti = data[333];
        data[332] = data[328] - tr;
        data[333] = data[329] - ti;
        data[328] += tr;
        data[329] += ti;
        tr = data[334];
        ti = data[335];
        data[334] = data[330] - tr;
        data[335] = data[331] - ti;
        data[330] += tr;
        data[331] += ti;
    }
    // N = 8, at 320
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 328 ] * wr - data[ i + 329 ] * wi;
            uniform float tempi  = data[ i + 328 ] * wi + data[ i + 329 ] * wr;
            uniform float tempr2 = data[ i + 330 ] * wr2 - data[ i + 331 ] * wi2;
            uniform float tempi2 = data[ i + 330 ] * wi2 + data[ i + 331 ] * wr2;
            data[ i + 328 ] = data[ 320 + i ] - tempr;
            data[ i + 329 ] = data[ 321 + i ] - tempi;
            data[ i + 330 ] = data[ 322 + i ] - tempr2;
            data[ i + 331 ] = data[ 323 + i ] - tempi2;
            data[ 320 + i ] += tempr;
            data[ 321 + i ] += tempi;
            data[ 322 + i ] += tempr2;
            data[ 323 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 336
    {
        uniform float tr = data[338];
        uniform float ti = data[339];
        data[338] = data[336] - tr;
        data[339] = data[337] - ti;
        data[336] += tr;
        data[337] += ti;
        tr = data[342];
        ti = data[343];
        data[342] = data[341] - ti;
        data[343] = tr - data[340];
        data[340] += tr;
        data[341] += ti;
        tr = data[340];
        ti = data[341];
        data[340] = data[336] - tr;
        data[341] = data[337] - ti;
        data[336] += tr;
        data[337] += ti;
        tr = data[342];
        ti = data[343];
        data[342] = data[338] - tr;
        data[343] = data[339] - ti;
        data[338] += tr;
        data[339] += ti;
    }
    // N = 4, at 344
    {
        uniform float tr = data[346];
        uniform float ti = data[347];
        data[346] = data[344] - tr;
        data[347] = data[345] - ti;
        data[344] += tr;
        data[345] += ti;
        tr = data[350];
        ti = data[351];
        data[350] = data[349] - ti;
        data[351] = tr - data[348];
        data[348] += tr;
        data[349] += ti;
        tr = data[348];
        ti = data[349];
        data[348] = data[344] - tr;
        data[349] = data[345] - ti;
        data[344] += tr;
        data[345] += ti;
        tr = data[350];
        ti = data[351];
        data[350] = data[346] - tr;
        data[351] = data[347] - ti;
        data[346] += tr;
        data[347] += ti;
    }
    // N = 8, at 336
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 344 ] * wr - data[ i + 345 ] * wi;
            uniform float tempi  = data[ i + 344 ] * wi + data[ i + 345 ] * wr;
            uniform float tempr2 = data[ i + 346 ] * wr2 - data[ i + 347 ] * wi2;
            uniform float tempi2 = data[ i + 346 ] * wi2 + data[ i + 347 ] * wr2;
            data[ i + 344 ] = data[ 336 + i ] - tempr;
            data[ i + 345 ] = data[ 337 + i ] - tempi;
            data[ i + 346 ] = data[ 338 + i ] - tempr2;
            data[ i + 347 ] = data[ 339 + i ] - tempi2;
            data[ 336 + i ] += tempr;
            data[ 337 + i ] += tempi;
            data[ 338 + i ] += tempr2;
            data[ 339 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 320
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 336 ] * wr - data[ i + 337 ] * wi;
            uniform float tempi  = data[ i + 336 ] * wi + data[ i + 337 ] * wr;
            uniform float tempr2 = data[ i + 338 ] * wr2 - data[ i + 339 ] * wi2;
            uniform float tempi2 = data[ i + 338 ] * wi2 + data[ i + 339 ] * wr2;
            data[ i + 336 ] = data[ 320 + i ] - tempr;
            data[ i + 337 ] = data[ 321 + i ] - tempi;
            data[ i + 338 ] = data[ 322 + i ] - tempr2;
            data[ i + 339 ] = data[ 323 + i ] - tempi2;
            data[ 320 + i ] += tempr;
            data[ 321 + i ] += tempi;
            data[ 322 + i ] += tempr2;
            data[ 323 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 352
    {
        uniform float tr = data[354];
        uniform float ti = data[355];
        data[354] = data[352] - tr;
        data[355] = data[353] - ti;
        data[352] += tr;
        data[353] += ti;
        tr = data[358];
        ti = data[359];
        data[358] = data[357] - ti;
        data[359] = tr - data[356];
        data[356] += tr;
        data[357] += ti;
        tr = data[356];
        ti = data[357];
        data[356] = data[352] - tr;
        data[357] = data[353] - ti;
        data[352] += tr;
        data[353] += ti;
        tr = data[358];
        ti = data[359];
        data[358] = data[354] - tr;
        data[359] = data[355] - ti;
        data[354] += tr;
        data[355] += ti;
    }
    // N = 4, at 360
    {
        uniform float tr = data[362];
        uniform float ti = data[363];
        data[362] = data[360] - tr;
        data[363] = data[361] - ti;
        data[360] += tr;
        data[361] += ti;
        tr = data[366];
        ti = data[367];
        data[366] = data[365] - ti;
        data[367] = tr - data[364];
        data[364] += tr;
        data[365] += ti;
        tr = data[364];
        ti = data[365];
        data[364] = data[360] - tr;
        data[365] = data[361] - ti;
        data[360] += tr;
        data[361] += ti;
        tr = data[366];
        ti = data[367];
        data[366] = data[362] - tr;
        data[367] = data[363] - ti;
        data[362] += tr;
        data[363] += ti;
    }
    // N = 8, at 352
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 360 ] * wr - data[ i + 361 ] * wi;
            uniform float tempi  = data[ i + 360 ] * wi + data[ i + 361 ] * wr;
            uniform float tempr2 = data[ i + 362 ] * wr2 - data[ i + 363 ] * wi2;
            uniform float tempi2 = data[ i + 362 ] * wi2 + data[ i + 363 ] * wr2;
            data[ i + 360 ] = data[ 352 + i ] - tempr;
            data[ i + 361 ] = data[ 353 + i ] - tempi;
            data[ i + 362 ] = data[ 354 + i ] - tempr2;
            data[ i + 363 ] = data[ 355 + i ] - tempi2;
            data[ 352 + i ] += tempr;
            data[ 353 + i ] += tempi;
            data[ 354 + i ] += tempr2;
            data[ 355 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 368
    {
        uniform float tr = data[370];
        uniform float ti = data[371];
        data[370] = data[368] - tr;
        data[371] = data[369] - ti;
        data[368] += tr;
        data[369] += ti;
        tr = data[374];
        ti = data[375];
        data[374] = data[373] - ti;
        data[375] = tr - data[372];
        data[372] += tr;
        data[373] += ti;
        tr = data[372];
        ti = data[373];
        data[372] = data[368] - tr;
        data[373] = data[369] - ti;
        data[368] += tr;
        data[369] += ti;
        tr = data[374];
        ti = data[375];
        data[374] = data[370] - tr;
        data[375] = data[371] - ti;
        data[370] += tr;
        data[371] += ti;
    }
    // N = 4, at 376
    {
        uniform float tr = data[378];
        uniform float ti = data[379];
        data[378] = data[376] - tr;
        data[379] = data[377] - ti;
        data[376] += tr;
        data[377] += ti;
        tr = data[382];
        ti = data[383];
        data[382] = data[381] - ti;
        data[383] = tr - data[380];
        data[380] += tr;
        data[381] += ti;
        tr = data[380];
        ti = data[381];
        data[380] = data[376] - tr;
        data[381] = data[377] - ti;
        data[376] += tr;
        data[377] += ti;
        tr = data[382];
        ti = data[383];
        data[382] = data[378] - tr;
        data[383] = data[379] - ti;
        data[378] += tr;
        data[379] += ti;
    }
    // N = 8, at 368
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 376 ] * wr - data[ i + 377 ] * wi;
            uniform float tempi  = data[ i + 376 ] * wi + data[ i + 377 ] * wr;
            uniform float tempr2 = data[ i + 378 ] * wr2 - data[ i + 379 ] * wi2;
            uniform float tempi2 = data[ i + 378 ] * wi2 + data[ i + 379 ] * wr2;
            data[ i + 376 ] = data[ 368 + i ] - tempr;
            data[ i + 377 ] = data[ 369 + i ] - tempi;
            data[ i + 378 ] = data[ 370 + i ] - tempr2;
            data[ i + 379 ] = data[ 371 + i ] - tempi2;
            data[ 368 + i ] += tempr;
            data[ 369 + i ] += tempi;
            data[ 370 + i ] += tempr2;
            data[ 371 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 352
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 368 ] * wr - data[ i + 369 ] * wi;
            uniform float tempi  = data[ i + 368 ] * wi + data[ i + 369 ] * wr;
            uniform float tempr2 = data[ i + 370 ] * wr2 - data[ i + 371 ] * wi2;
            uniform float tempi2 = data[ i + 370 ] * wi2 + data[ i + 371 ] * wr2;
            data[ i + 368 ] = data[ 352 + i ] - tempr;
            data[ i + 369 ] = data[ 353 + i ] - tempi;
            data[ i + 370 ] = data[ 354 + i ] - tempr2;
            data[ i + 371 ] = data[ 355 + i ] - tempi2;
            data[ 352 + i ] += tempr;
            data[ 353 + i ] += tempi;
            data[ 354 + i ] += tempr2;
            data[ 355 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 320
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 352 ] * wr - data[ i + 353 ] * wi;
            uniform float tempi  = data[ i + 352 ] * wi + data[ i + 353 ] * wr;
            uniform float tempr2 = data[ i + 354 ] * wr2 - data[ i + 355 ] * wi2;
            uniform float tempi2 = data[ i + 354 ] * wi2 + data[ i + 355 ] * wr2;
            data[ i + 352 ] = data[ 320 + i ] - tempr;
            data[ i + 353 ] = data[ 321 + i ] - tempi;
            data[ i + 354 ] = data[ 322 + i ] - tempr2;
            data[ i + 355 ] = data[ 323 + i ] - tempi2;
            data[ 320 + i ] += tempr;
            data[ 321 + i ] += tempi;
            data[ 322 + i ] += tempr2;
            data[ 323 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 256
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 320 ] * wr - data[ i + 321 ] * wi;
            uniform float tempi  = data[ i + 320 ] * wi + data[ i + 321 ] * wr;
            uniform float tempr2 = data[ i + 322 ] * wr2 - data[ i + 323 ] * wi2;
            uniform float tempi2 = data[ i + 322 ] * wi2 + data[ i + 323 ] * wr2;
            data[ i + 320 ] = data[ 256 + i ] - tempr;
            data[ i + 321 ] = data[ 257 + i ] - tempi;
            data[ i + 322 ] = data[ 258 + i ] - tempr2;
            data[ i + 323 ] = data[ 259 + i ] - tempi2;
            data[ 256 + i ] += tempr;
            data[ 257 + i ] += tempi;
            data[ 258 + i ] += tempr2;
            data[ 259 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 384
    {
        uniform float tr = data[386];
        uniform float ti = data[387];
        data[386] = data[384] - tr;
        data[387] = data[385] - ti;
        data[384] += tr;
        data[385] += ti;
        tr = data[390];
        ti = data[391];
        data[390] = data[389] - ti;
        data[391] = tr - data[388];
        data[388] += tr;
        data[389] += ti;
        tr = data[388];
        ti = data[389];
        data[388] = data[384] - tr;
        data[389] = data[385] - ti;
        data[384] += tr;
        data[385] += ti;
        tr = data[390];
        ti = data[391];
        data[390] = data[386] - tr;
        data[391] = data[387] - ti;
        data[386] += tr;
        data[387] += ti;
    }
    // N = 4, at 392
    {
        uniform float tr = data[394];
        uniform float ti = data[395];
        data[394] = data[392] - tr;
        data[395] = data[393] - ti;
        data[392] += tr;
        data[393] += ti;
        tr = data[398];
        ti = data[399];
        data[398] = data[397] - ti;
        data[399] = tr - data[396];
        data[396] += tr;
        data[397] += ti;
        tr = data[396];
        ti = data[397];
        data[396] = data[392] - tr;
        data[397] = data[393] - ti;
        data[392] += tr;
        data[393] += ti;
        tr = data[398];
        ti = data[399];
        data[398] = data[394] - tr;
        data[399] = data[395] - ti;
        data[394] += tr;
        data[395] += ti;
    }
    // N = 8, at 384
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 392 ] * wr - data[ i + 393 ] * wi;
            uniform float tempi  = data[ i + 392 ] * wi + data[ i + 393 ] * wr;
            uniform float tempr2 = data[ i + 394 ] * wr2 - data[ i + 395 ] * wi2;
            uniform float tempi2 = data[ i + 394 ] * wi2 + data[ i + 395 ] * wr2;
            data[ i + 392 ] = data[ 384 + i ] - tempr;
            data[ i + 393 ] = data[ 385 + i ] - tempi;
            data[ i + 394 ] = data[ 386 + i ] - tempr2;
            data[ i + 395 ] = data[ 387 + i ] - tempi2;
            data[ 384 + i ] += tempr;
            data[ 385 + i ] += tempi;
            data[ 386 + i ] += tempr2;
            data[ 387 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 400
    {
        uniform float tr = data[402];
        uniform float ti = data[403];
        data[402] = data[400] - tr;
        data[403] = data[401] - ti;
        data[400] += tr;
        data[401] += ti;
        tr = data[406];
        ti = data[407];
        data[406] = data[405] - ti;
        data[407] = tr - data[404];
        data[404] += tr;
        data[405] += ti;
        tr = data[404];
        ti = data[405];
        data[404] = data[400] - tr;
        data[405] = data[401] - ti;
        data[400] += tr;
        data[401] += ti;
        tr = data[406];
        ti = data[407];
        data[406] = data[402] - tr;
        data[407] = data[403] - ti;
        data[402] += tr;
        data[403] += ti;
    }
    // N = 4, at 408
    {
        uniform float tr = data[410];
        uniform float ti = data[411];
        data[410] = data[408] - tr;
        data[411] = data[409] - ti;
        data[408] += tr;
        data[409] += ti;
        tr = data[414];
        ti = data[415];
        data[414] = data[413] - ti;
        data[415] = tr - data[412];
        data[412] += tr;
        data[413] += ti;
        tr = data[412];
        ti = data[413];
        data[412] = data[408] - tr;
        data[413] = data[409] - ti;
        data[408] += tr;
        data[409] += ti;
        tr = data[414];
        ti = data[415];
        data[414] = data[410] - tr;
        data[415] = data[411] - ti;
        data[410] += tr;
        data[411] += ti;
    }
    // N = 8, at 400
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 408 ] * wr - data[ i + 409 ] * wi;
            uniform float tempi  = data[ i + 408 ] * wi + data[ i + 409 ] * wr;
            uniform float tempr2 = data[ i + 410 ] * wr2 - data[ i + 411 ] * wi2;
            uniform float tempi2 = data[ i + 410 ] * wi2 + data[ i + 411 ] * wr2;
            data[ i + 408 ] = data[ 400 + i ] - tempr;
            data[ i + 409 ] = data[ 401 + i ] - tempi;
            data[ i + 410 ] = data[ 402 + i ] - tempr2;
            data[ i + 411 ] = data[ 403 + i ] - tempi2;
            data[ 400 + i ] += tempr;
            data[ 401 + i ] += tempi;
            data[ 402 + i ] += tempr2;
            data[ 403 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 384
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 400 ] * wr - data[ i + 401 ] * wi;
            uniform float tempi  = data[ i + 400 ] * wi + data[ i + 401 ] * wr;
            uniform float tempr2 = data[ i + 402 ] * wr2 - data[ i + 403 ] * wi2;
            uniform float tempi2 = data[ i + 402 ] * wi2 + data[ i + 403 ] * wr2;
            data[ i + 400 ] = data[ 384 + i ] - tempr;
            data[ i + 401 ] = data[ 385 + i ] - tempi;
            data[ i + 402 ] = data[ 386 + i ] - tempr2;
            data[ i + 403 ] = data[ 387 + i ] - tempi2;
            data[ 384 + i ] += tempr;
            data[ 385 + i ] += tempi;
            data[ 386 + i ] += tempr2;
            data[ 387 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 416
    {
        uniform float tr = data[418];
        uniform float ti = data[419];
        data[418] = data[416] - tr;
        data[419] = data[417] - ti;
        data[416] += tr;
        data[417] += ti;
        tr = data[422];
        ti = data[423];
        data[422] = data[421] - ti;
        data[423] = tr - data[420];
        data[420] += tr;
        data[421] += ti;
        tr = data[420];
        ti = data[421];
        data[420] = data[416] - tr;
        data[421] = data[417] - ti;
        data[416] += tr;
        data[417] += ti;
        tr = data[422];
        ti = data[423];
        data[422] = data[418] - tr;
        data[423] = data[419] - ti;
        data[418] += tr;
        data[419] += ti;
    }
    // N = 4, at 424
    {
        uniform float tr = data[426];
        uniform float ti = data[427];
        data[426] = data[424] - tr;
        data[427] = data[425] - ti;
        data[424] += tr;
        data[425] += ti;
        tr = data[430];
        ti = data[431];
        data[430] = data[429] - ti;
        data[431] = tr - data[428];
        data[428] += tr;
        data[429] += ti;
        tr = data[428];
        ti = data[429];
        data[428] = data[424] - tr;
        data[429] = data[425] - ti;
        data[424] += tr;
        data[425] += ti;
        tr = data[430];
        ti = data[431];
        data[430] = data[426] - tr;
        data[431] = data[427] - ti;
        data[426] += tr;
        data[427] += ti;
    }
    // N = 8, at 416
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 424 ] * wr - data[ i + 425 ] * wi;
            uniform float tempi  = data[ i + 424 ] * wi + data[ i + 425 ] * wr;
            uniform float tempr2 = data[ i + 426 ] * wr2 - data[ i + 427 ] * wi2;
            uniform float tempi2 = data[ i + 426 ] * wi2 + data[ i + 427 ] * wr2;
            data[ i + 424 ] = data[ 416 + i ] - tempr;
            data[ i + 425 ] = data[ 417 + i ] - tempi;
            data[ i + 426 ] = data[ 418 + i ] - tempr2;
            data[ i + 427 ] = data[ 419 + i ] - tempi2;
            data[ 416 + i ] += tempr;
            data[ 417 + i ] += tempi;
            data[ 418 + i ] += tempr2;
            data[ 419 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 432
    {
        uniform float tr = data[434];
        uniform float ti = data[435];
        data[434] = data[432] - tr;
        data[435] = data[433] - ti;
        data[432] += tr;
        data[433] += ti;
        tr = data[438];
        ti = data[439];
        data[438] = data[437] - ti;
        data[439] = tr - data[436];
        data[436] += tr;
        data[437] += ti;
        tr = data[436];
        ti = data[437];
        data[436] = data[432] - tr;
        data[437] = data[433] - ti;
        data[432] += tr;
        data[433] += ti;
        tr = data[438];
        ti = data[439];
        data[438] = data[434] - tr;
        data[439] = data[435] - ti;
        data[434] += tr;
        data[435] += ti;
    }
    // N = 4, at 440
    {
        uniform float tr = data[442];
        uniform float ti = data[443];
        data[442] = data[440] - tr;
        data[443] = data[441] - ti;
        data[440] += tr;
        data[441] += ti;
        tr = data[446];
        ti = data[447];
        data[446] = data[445] - ti;
        data[447] = tr - data[444];
        data[444] += tr;
        data[445] += ti;
        tr = data[444];
        ti = data[445];
        data[444] = data[440] - tr;
        data[445] = data[441] - ti;
        data[440] += tr;
        data[441] += ti;
        tr = data[446];
        ti = data[447];
        data[446] = data[442] - tr;
        data[447] = data[443] - ti;
        data[442] += tr;
        data[443] += ti;
    }
    // N = 8, at 432
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 440 ] * wr - data[ i + 441 ] * wi;
            uniform float tempi  = data[ i + 440 ] * wi + data[ i + 441 ] * wr;
            uniform float tempr2 = data[ i + 442 ] * wr2 - data[ i + 443 ] * wi2;
            uniform float tempi2 = data[ i + 442 ] * wi2 + data[ i + 443 ] * wr2;
            data[ i + 440 ] = data[ 432 + i ] - tempr;
            data[ i + 441 ] = data[ 433 + i ] - tempi;
            data[ i + 442 ] = data[ 434 + i ] - tempr2;
            data[ i + 443 ] = data[ 435 + i ] - tempi2;
            data[ 432 + i ] += tempr;
            data[ 433 + i ] += tempi;
            data[ 434 + i ] += tempr2;
            data[ 435 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 416
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 432 ] * wr - data[ i + 433 ] * wi;
            uniform float tempi  = data[ i + 432 ] * wi + data[ i + 433 ] * wr;
            uniform float tempr2 = data[ i + 434 ] * wr2 - data[ i + 435 ] * wi2;
            uniform float tempi2 = data[ i + 434 ] * wi2 + data[ i + 435 ] * wr2;
            data[ i + 432 ] = data[ 416 + i ] - tempr;
            data[ i + 433 ] = data[ 417 + i ] - tempi;
            data[ i + 434 ] = data[ 418 + i ] - tempr2;
            data[ i + 435 ] = data[ 419 + i ] - tempi2;
            data[ 416 + i ] += tempr;
            data[ 417 + i ] += tempi;
            data[ 418 + i ] += tempr2;
            data[ 419 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 384
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 416 ] * wr - data[ i + 417 ] * wi;
            uniform float tempi  = data[ i + 416 ] * wi + data[ i + 417 ] * wr;
            uniform float tempr2 = data[ i + 418 ] * wr2 - data[ i + 419 ] * wi2;
            uniform float tempi2 = data[ i + 418 ] * wi2 + data[ i + 419 ] * wr2;
            data[ i + 416 ] = data[ 384 + i ] - tempr;
            data[ i + 417 ] = data[ 385 + i ] - tempi;
            data[ i + 418 ] = data[ 386 + i ] - tempr2;
            data[ i + 419 ] = data[ 387 + i ] - tempi2;
            data[ 384 + i ] += tempr;
            data[ 385 + i ] += tempi;
            data[ 386 + i ] += tempr2;
            data[ 387 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 448
    {
        uniform float tr = data[450];
        uniform float ti = data[451];
        data[450] = data[448] - tr;
        data[451] = data[449] - ti;
        data[448] += tr;
        data[449] += ti;
        tr = data[454];
        ti = data[455];
        data[454] = data[453] - ti;
        data[455] = tr - data[452];
        data[452] += tr;
        data[453] += ti;
        tr = data[452];
        ti = data[453];
        data[452] = data[448] - tr;
        data[453] = data[449] - ti;
        data[448] += tr;
        data[449] += ti;
        tr = data[454];
        ti = data[455];
        data[454] = data[450] - tr;
        data[455] = data[451] - ti;
        data[450] += tr;
        data[451] += ti;
    }
    // N = 4, at 456
    {
        uniform float tr = data[458];
        uniform float ti = data[459];
        data[458] = data[456] - tr;
        data[459] = data[457] - ti;
        data[456] += tr;
        data[457] += ti;
        tr = data[462];
        ti = data[463];
        data[462] = data[461] - ti;
        data[463] = tr - data[460];
        data[460] += tr;
        data[461] += ti;
        tr = data[460];
        ti = data[461];
        data[460] = data[456] - tr;
        data[461] = data[457] - ti;
        data[456] += tr;
        data[457] += ti;
        tr = data[462];
        ti = data[463];
        data[462] = data[458] - tr;
        data[463] = data[459] - ti;
        data[458] += tr;
        data[459] += ti;
    }
    // N = 8, at 448
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 456 ] * wr - data[ i + 457 ] * wi;
            uniform float tempi  = data[ i + 456 ] * wi + data[ i + 457 ] * wr;
            uniform float tempr2 = data[ i + 458 ] * wr2 - data[ i + 459 ] * wi2;
            uniform float tempi2 = data[ i + 458 ] * wi2 + data[ i + 459 ] * wr2;
            data[ i + 456 ] = data[ 448 + i ] - tempr;
            data[ i + 457 ] = data[ 449 + i ] - tempi;
            data[ i + 458 ] = data[ 450 + i ] - tempr2;
            data[ i + 459 ] = data[ 451 + i ] - tempi2;
            data[ 448 + i ] += tempr;
            data[ 449 + i ] += tempi;
            data[ 450 + i ] += tempr2;
            data[ 451 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 464
    {
        uniform float tr = data[466];
        uniform float ti = data[467];
        data[466] = data[464] - tr;
        data[467] = data[465] - ti;
        data[464] += tr;
        data[465] += ti;
        tr = data[470];
        ti = data[471];
        data[470] = data[469] - ti;
        data[471] = tr - data[468];
        data[468] += tr;
        data[469] += ti;
        tr = data[468];
        ti = data[469];
        data[468] = data[464] - tr;
        data[469] = data[465] - ti;
        data[464] += tr;
        data[465] += ti;
        tr = data[470];
        ti = data[471];
        data[470] = data[466] - tr;
        data[471] = data[467] - ti;
        data[466] += tr;
        data[467] += ti;
    }
    // N = 4, at 472
    {
        uniform float tr = data[474];
        uniform float ti = data[475];
        data[474] = data[472] - tr;
        data[475] = data[473] - ti;
        data[472] += tr;
        data[473] += ti;
        tr = data[478];
        ti = data[479];
        data[478] = data[477] - ti;
        data[479] = tr - data[476];
        data[476] += tr;
        data[477] += ti;
        tr = data[476];
        ti = data[477];
        data[476] = data[472] - tr;
        data[477] = data[473] - ti;
        data[472] += tr;
        data[473] += ti;
        tr = data[478];
        ti = data[479];
        data[478] = data[474] - tr;
        data[479] = data[475] - ti;
        data[474] += tr;
        data[475] += ti;
    }
    // N = 8, at 464
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 472 ] * wr - data[ i + 473 ] * wi;
            uniform float tempi  = data[ i + 472 ] * wi + data[ i + 473 ] * wr;
            uniform float tempr2 = data[ i + 474 ] * wr2 - data[ i + 475 ] * wi2;
            uniform float tempi2 = data[ i + 474 ] * wi2 + data[ i + 475 ] * wr2;
            data[ i + 472 ] = data[ 464 + i ] - tempr;
            data[ i + 473 ] = data[ 465 + i ] - tempi;
            data[ i + 474 ] = data[ 466 + i ] - tempr2;
            data[ i + 475 ] = data[ 467 + i ] - tempi2;
            data[ 464 + i ] += tempr;
            data[ 465 + i ] += tempi;
            data[ 466 + i ] += tempr2;
            data[ 467 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 448
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 464 ] * wr - data[ i + 465 ] * wi;
            uniform float tempi  = data[ i + 464 ] * wi + data[ i + 465 ] * wr;
            uniform float tempr2 = data[ i + 466 ] * wr2 - data[ i + 467 ] * wi2;
            uniform float tempi2 = data[ i + 466 ] * wi2 + data[ i + 467 ] * wr2;
            data[ i + 464 ] = data[ 448 + i ] - tempr;
            data[ i + 465 ] = data[ 449 + i ] - tempi;
            data[ i + 466 ] = data[ 450 + i ] - tempr2;
            data[ i + 467 ] = data[ 451 + i ] - tempi2;
            data[ 448 + i ] += tempr;
            data[ 449 + i ] += tempi;
            data[ 450 + i ] += tempr2;
            data[ 451 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 480
    {
        uniform float tr = data[482];
        uniform float ti = data[483];
        data[482] = data[480] - tr;
        data[483] = data[481] - ti;
        data[480] += tr;
        data[481] += ti;
        tr = data[486];
        ti = data[487];
        data[486] = data[485] - ti;
        data[487] = tr - data[484];
        data[484] += tr;
        data[485] += ti;
        tr = data[484];
        ti = data[485];
        data[484] = data[480] - tr;
        data[485] = data[481] - ti;
        data[480] += tr;
        data[481] += ti;
        tr = data[486];
        ti = data[487];
        data[486] = data[482] - tr;
        data[487] = data[483] - ti;
        data[482] += tr;
        data[483] += ti;
    }
    // N = 4, at 488
    {
        uniform float tr = data[490];
        uniform float ti = data[491];
        data[490] = data[488] - tr;
        data[491] = data[489] - ti;
        data[488] += tr;
        data[489] += ti;
        tr = data[494];
        ti = data[495];
        data[494] = data[493] - ti;
        data[495] = tr - data[492];
        data[492] += tr;
        data[493] += ti;
        tr = data[492];
        ti = data[493];
        data[492] = data[488] - tr;
        data[493] = data[489] - ti;
        data[488] += tr;
        data[489] += ti;
        tr = data[494];
        ti = data[495];
        data[494] = data[490] - tr;
        data[495] = data[491] - ti;
        data[490] += tr;
        data[491] += ti;
    }
    // N = 8, at 480
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 488 ] * wr - data[ i + 489 ] * wi;
            uniform float tempi  = data[ i + 488 ] * wi + data[ i + 489 ] * wr;
            uniform float tempr2 = data[ i + 490 ] * wr2 - data[ i + 491 ] * wi2;
            uniform float tempi2 = data[ i + 490 ] * wi2 + data[ i + 491 ] * wr2;
            data[ i + 488 ] = data[ 480 + i ] - tempr;
            data[ i + 489 ] = data[ 481 + i ] - tempi;
            data[ i + 490 ] = data[ 482 + i ] - tempr2;
            data[ i + 491 ] = data[ 483 + i ] - tempi2;
            data[ 480 + i ] += tempr;
            data[ 481 + i ] += tempi;
            data[ 482 + i ] += tempr2;
            data[ 483 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 496
    {
        uniform float tr = data[498];
        uniform float ti = data[499];
        data[498] = data[496] - tr;
        data[499] = data[497] - ti;
        data[496] += tr;
        data[497] += ti;
        tr = data[502];
        ti = data[503];
        data[502] = data[501] - ti;
        data[503] = tr - data[500];
        data[500] += tr;
        data[501] += ti;
        tr = data[500];
        ti = data[501];
        data[500] = data[496] - tr;
        data[501] = data[497] - ti;
        data[496] += tr;
        data[497] += ti;
        tr = data[502];
        ti = data[503];
        data[502] = data[498] - tr;
        data[503] = data[499] - ti;
        data[498] += tr;
        data[499] += ti;
    }
    // N = 4, at 504
    {
        uniform float tr = data[506];
        uniform float ti = data[507];
        data[506] = data[504] - tr;
        data[507] = data[505] - ti;
        data[504] += tr;
        data[505] += ti;
        tr = data[510];
        ti = data[511];
        data[510] = data[509] - ti;
        data[511] = tr - data[508];
        data[508] += tr;
        data[509] += ti;
        tr = data[508];
        ti = data[509];
        data[508] = data[504] - tr;
        data[509] = data[505] - ti;
        data[504] += tr;
        data[505] += ti;
        tr = data[510];
        ti = data[511];
        data[510] = data[506] - tr;
        data[511] = data[507] - ti;
        data[506] += tr;
        data[507] += ti;
    }
    // N = 8, at 496
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 504 ] * wr - data[ i + 505 ] * wi;
            uniform float tempi  = data[ i + 504 ] * wi + data[ i + 505 ] * wr;
            uniform float tempr2 = data[ i + 506 ] * wr2 - data[ i + 507 ] * wi2;
            uniform float tempi2 = data[ i + 506 ] * wi2 + data[ i + 507 ] * wr2;
            data[ i + 504 ] = data[ 496 + i ] - tempr;
            data[ i + 505 ] = data[ 497 + i ] - tempi;
            data[ i + 506 ] = data[ 498 + i ] - tempr2;
            data[ i + 507 ] = data[ 499 + i ] - tempi2;
            data[ 496 + i ] += tempr;
            data[ 497 + i ] += tempi;
            data[ 498 + i ] += tempr2;
            data[ 499 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 480
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 496 ] * wr - data[ i + 497 ] * wi;
            uniform float tempi  = data[ i + 496 ] * wi + data[ i + 497 ] * wr;
            uniform float tempr2 = data[ i + 498 ] * wr2 - data[ i + 499 ] * wi2;
            uniform float tempi2 = data[ i + 498 ] * wi2 + data[ i + 499 ] * wr2;
            data[ i + 496 ] = data[ 480 + i ] - tempr;
            data[ i + 497 ] = data[ 481 + i ] - tempi;
            data[ i + 498 ] = data[ 482 + i ] - tempr2;
            data[ i + 499 ] = data[ 483 + i ] - tempi2;
            data[ 480 + i ] += tempr;
            data[ 481 + i ] += tempi;
            data[ 482 + i ] += tempr2;
            data[ 483 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 448
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 480 ] * wr - data[ i + 481 ] * wi;
            uniform float tempi  = data[ i + 480 ] * wi + data[ i + 481 ] * wr;
            uniform float tempr2 = data[ i + 482 ] * wr2 - data[ i + 483 ] * wi2;
            uniform float tempi2 = data[ i + 482 ] * wi2 + data[ i + 483 ] * wr2;
            data[ i + 480 ] = data[ 448 + i ] - tempr;
            data[ i + 481 ] = data[ 449 + i ] - tempi;
            data[ i + 482 ] = data[ 450 + i ] - tempr2;
            data[ i + 483 ] = data[ 451 + i ] - tempi2;
            data[ 448 + i ] += tempr;
            data[ 449 + i ] += tempi;
            data[ 450 + i ] += tempr2;
            data[ 451 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 384
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 448 ] * wr - data[ i + 449 ] * wi;
            uniform float tempi  = data[ i + 448 ] * wi + data[ i + 449 ] * wr;
            uniform float tempr2 = data[ i + 450 ] * wr2 - data[ i + 451 ] * wi2;
            uniform float tempi2 = data[ i + 450 ] * wi2 + data[ i + 451 ] * wr2;
            data[ i + 448 ] = data[ 384 + i ] - tempr;
            data[ i + 449 ] = data[ 385 + i ] - tempi;
            data[ i + 450 ] = data[ 386 + i ] - tempr2;
            data[ i + 451 ] = data[ 387 + i ] - tempi2;
            data[ 384 + i ] += tempr;
            data[ 385 + i ] += tempi;
            data[ 386 + i ] += tempr2;
            data[ 387 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 256
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 384 ] * wr - data[ i + 385 ] * wi;
            uniform float tempi  = data[ i + 384 ] * wi + data[ i + 385 ] * wr;
            uniform float tempr2 = data[ i + 386 ] * wr2 - data[ i + 387 ] * wi2;
            uniform float tempi2 = data[ i + 386 ] * wi2 + data[ i + 387 ] * wr2;
            data[ i + 384 ] = data[ 256 + i ] - tempr;
            data[ i + 385 ] = data[ 257 + i ] - tempi;
            data[ i + 386 ] = data[ 258 + i ] - tempr2;
            data[ i + 387 ] = data[ 259 + i ] - tempi2;
            data[ 256 + i ] += tempr;
            data[ 257 + i ] += tempi;
            data[ 258 + i ] += tempr2;
            data[ 259 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 256, at 0
    {
        uniform const_expr float sina = -0.012271538627185888531423f;
        uniform const_expr float sinb = -0.024541229205668591006884f;

        uniform const_expr float wpr = -0.000301181320557030655742f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 256; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 256 ] * wr - data[ i + 257 ] * wi;
            uniform float tempi  = data[ i + 256 ] * wi + data[ i + 257 ] * wr;
            uniform float tempr2 = data[ i + 258 ] * wr2 - data[ i + 259 ] * wi2;
            uniform float tempi2 = data[ i + 258 ] * wi2 + data[ i + 259 ] * wr2;
            data[ i + 256 ] = data[ 0 + i ] - tempr;
            data[ i + 257 ] = data[ 1 + i ] - tempi;
            data[ i + 258 ] = data[ 2 + i ] - tempr2;
            data[ i + 259 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 512
    {
        uniform float tr = data[514];
        uniform float ti = data[515];
        data[514] = data[512] - tr;
        data[515] = data[513] - ti;
        data[512] += tr;
        data[513] += ti;
        tr = data[518];
        ti = data[519];
        data[518] = data[517] - ti;
        data[519] = tr - data[516];
        data[516] += tr;
        data[517] += ti;
        tr = data[516];
        ti = data[517];
        data[516] = data[512] - tr;
        data[517] = data[513] - ti;
        data[512] += tr;
        data[513] += ti;
        tr = data[518];
        ti = data[519];
        data[518] = data[514] - tr;
        data[519] = data[515] - ti;
        data[514] += tr;
        data[515] += ti;
    }
    // N = 4, at 520
    {
        uniform float tr = data[522];
        uniform float ti = data[523];
        data[522] = data[520] - tr;
        data[523] = data[521] - ti;
        data[520] += tr;
        data[521] += ti;
        tr = data[526];
        ti = data[527];
        data[526] = data[525] - ti;
        data[527] = tr - data[524];
        data[524] += tr;
        data[525] += ti;
        tr = data[524];
        ti = data[525];
        data[524] = data[520] - tr;
        data[525] = data[521] - ti;
        data[520] += tr;
        data[521] += ti;
        tr = data[526];
        ti = data[527];
        data[526] = data[522] - tr;
        data[527] = data[523] - ti;
        data[522] += tr;
        data[523] += ti;
    }
    // N = 8, at 512
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 520 ] * wr - data[ i + 521 ] * wi;
            uniform float tempi  = data[ i + 520 ] * wi + data[ i + 521 ] * wr;
            uniform float tempr2 = data[ i + 522 ] * wr2 - data[ i + 523 ] * wi2;
            uniform float tempi2 = data[ i + 522 ] * wi2 + data[ i + 523 ] * wr2;
            data[ i + 520 ] = data[ 512 + i ] - tempr;
            data[ i + 521 ] = data[ 513 + i ] - tempi;
            data[ i + 522 ] = data[ 514 + i ] - tempr2;
            data[ i + 523 ] = data[ 515 + i ] - tempi2;
            data[ 512 + i ] += tempr;
            data[ 513 + i ] += tempi;
            data[ 514 + i ] += tempr2;
            data[ 515 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 528
    {
        uniform float tr = data[530];
        uniform float ti = data[531];
        data[530] = data[528] - tr;
        data[531] = data[529] - ti;
        data[528] += tr;
        data[529] += ti;
        tr = data[534];
        ti = data[535];
        data[534] = data[533] - ti;
        data[535] = tr - data[532];
        data[532] += tr;
        data[533] += ti;
        tr = data[532];
        ti = data[533];
        data[532] = data[528] - tr;
        data[533] = data[529] - ti;
        data[528] += tr;
        data[529] += ti;
        tr = data[534];
        ti = data[535];
        data[534] = data[530] - tr;
        data[535] = data[531] - ti;
        data[530] += tr;
        data[531] += ti;
    }
    // N = 4, at 536
    {
        uniform float tr = data[538];
        uniform float ti = data[539];
        data[538] = data[536] - tr;
        data[539] = data[537] - ti;
        data[536] += tr;
        data[537] += ti;
        tr = data[542];
        ti = data[543];
        data[542] = data[541] - ti;
        data[543] = tr - data[540];
        data[540] += tr;
        data[541] += ti;
        tr = data[540];
        ti = data[541];
        data[540] = data[536] - tr;
        data[541] = data[537] - ti;
        data[536] += tr;
        data[537] += ti;
        tr = data[542];
        ti = data[543];
        data[542] = data[538] - tr;
        data[543] = data[539] - ti;
        data[538] += tr;
        data[539] += ti;
    }
    // N = 8, at 528
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 536 ] * wr - data[ i + 537 ] * wi;
            uniform float tempi  = data[ i + 536 ] * wi + data[ i + 537 ] * wr;
            uniform float tempr2 = data[ i + 538 ] * wr2 - data[ i + 539 ] * wi2;
            uniform float tempi2 = data[ i + 538 ] * wi2 + data[ i + 539 ] * wr2;
            data[ i + 536 ] = data[ 528 + i ] - tempr;
            data[ i + 537 ] = data[ 529 + i ] - tempi;
            data[ i + 538 ] = data[ 530 + i ] - tempr2;
            data[ i + 539 ] = data[ 531 + i ] - tempi2;
            data[ 528 + i ] += tempr;
            data[ 529 + i ] += tempi;
            data[ 530 + i ] += tempr2;
            data[ 531 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 512
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 528 ] * wr - data[ i + 529 ] * wi;
            uniform float tempi  = data[ i + 528 ] * wi + data[ i + 529 ] * wr;
            uniform float tempr2 = data[ i + 530 ] * wr2 - data[ i + 531 ] * wi2;
            uniform float tempi2 = data[ i + 530 ] * wi2 + data[ i + 531 ] * wr2;
            data[ i + 528 ] = data[ 512 + i ] - tempr;
            data[ i + 529 ] = data[ 513 + i ] - tempi;
            data[ i + 530 ] = data[ 514 + i ] - tempr2;
            data[ i + 531 ] = data[ 515 + i ] - tempi2;
            data[ 512 + i ] += tempr;
            data[ 513 + i ] += tempi;
            data[ 514 + i ] += tempr2;
            data[ 515 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 544
    {
        uniform float tr = data[546];
        uniform float ti = data[547];
        data[546] = data[544] - tr;
        data[547] = data[545] - ti;
        data[544] += tr;
        data[545] += ti;
        tr = data[550];
        ti = data[551];
        data[550] = data[549] - ti;
        data[551] = tr - data[548];
        data[548] += tr;
        data[549] += ti;
        tr = data[548];
        ti = data[549];
        data[548] = data[544] - tr;
        data[549] = data[545] - ti;
        data[544] += tr;
        data[545] += ti;
        tr = data[550];
        ti = data[551];
        data[550] = data[546] - tr;
        data[551] = data[547] - ti;
        data[546] += tr;
        data[547] += ti;
    }
    // N = 4, at 552
    {
        uniform float tr = data[554];
        uniform float ti = data[555];
        data[554] = data[552] - tr;
        data[555] = data[553] - ti;
        data[552] += tr;
        data[553] += ti;
        tr = data[558];
        ti = data[559];
        data[558] = data[557] - ti;
        data[559] = tr - data[556];
        data[556] += tr;
        data[557] += ti;
        tr = data[556];
        ti = data[557];
        data[556] = data[552] - tr;
        data[557] = data[553] - ti;
        data[552] += tr;
        data[553] += ti;
        tr = data[558];
        ti = data[559];
        data[558] = data[554] - tr;
        data[559] = data[555] - ti;
        data[554] += tr;
        data[555] += ti;
    }
    // N = 8, at 544
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 552 ] * wr - data[ i + 553 ] * wi;
            uniform float tempi  = data[ i + 552 ] * wi + data[ i + 553 ] * wr;
            uniform float tempr2 = data[ i + 554 ] * wr2 - data[ i + 555 ] * wi2;
            uniform float tempi2 = data[ i + 554 ] * wi2 + data[ i + 555 ] * wr2;
            data[ i + 552 ] = data[ 544 + i ] - tempr;
            data[ i + 553 ] = data[ 545 + i ] - tempi;
            data[ i + 554 ] = data[ 546 + i ] - tempr2;
            data[ i + 555 ] = data[ 547 + i ] - tempi2;
            data[ 544 + i ] += tempr;
            data[ 545 + i ] += tempi;
            data[ 546 + i ] += tempr2;
            data[ 547 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 560
    {
        uniform float tr = data[562];
        uniform float ti = data[563];
        data[562] = data[560] - tr;
        data[563] = data[561] - ti;
        data[560] += tr;
        data[561] += ti;
        tr = data[566];
        ti = data[567];
        data[566] = data[565] - ti;
        data[567] = tr - data[564];
        data[564] += tr;
        data[565] += ti;
        tr = data[564];
        ti = data[565];
        data[564] = data[560] - tr;
        data[565] = data[561] - ti;
        data[560] += tr;
        data[561] += ti;
        tr = data[566];
        ti = data[567];
        data[566] = data[562] - tr;
        data[567] = data[563] - ti;
        data[562] += tr;
        data[563] += ti;
    }
    // N = 4, at 568
    {
        uniform float tr = data[570];
        uniform float ti = data[571];
        data[570] = data[568] - tr;
        data[571] = data[569] - ti;
        data[568] += tr;
        data[569] += ti;
        tr = data[574];
        ti = data[575];
        data[574] = data[573] - ti;
        data[575] = tr - data[572];
        data[572] += tr;
        data[573] += ti;
        tr = data[572];
        ti = data[573];
        data[572] = data[568] - tr;
        data[573] = data[569] - ti;
        data[568] += tr;
        data[569] += ti;
        tr = data[574];
        ti = data[575];
        data[574] = data[570] - tr;
        data[575] = data[571] - ti;
        data[570] += tr;
        data[571] += ti;
    }
    // N = 8, at 560
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 568 ] * wr - data[ i + 569 ] * wi;
            uniform float tempi  = data[ i + 568 ] * wi + data[ i + 569 ] * wr;
            uniform float tempr2 = data[ i + 570 ] * wr2 - data[ i + 571 ] * wi2;
            uniform float tempi2 = data[ i + 570 ] * wi2 + data[ i + 571 ] * wr2;
            data[ i + 568 ] = data[ 560 + i ] - tempr;
            data[ i + 569 ] = data[ 561 + i ] - tempi;
            data[ i + 570 ] = data[ 562 + i ] - tempr2;
            data[ i + 571 ] = data[ 563 + i ] - tempi2;
            data[ 560 + i ] += tempr;
            data[ 561 + i ] += tempi;
            data[ 562 + i ] += tempr2;
            data[ 563 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 544
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 560 ] * wr - data[ i + 561 ] * wi;
            uniform float tempi  = data[ i + 560 ] * wi + data[ i + 561 ] * wr;
            uniform float tempr2 = data[ i + 562 ] * wr2 - data[ i + 563 ] * wi2;
            uniform float tempi2 = data[ i + 562 ] * wi2 + data[ i + 563 ] * wr2;
            data[ i + 560 ] = data[ 544 + i ] - tempr;
            data[ i + 561 ] = data[ 545 + i ] - tempi;
            data[ i + 562 ] = data[ 546 + i ] - tempr2;
            data[ i + 563 ] = data[ 547 + i ] - tempi2;
            data[ 544 + i ] += tempr;
            data[ 545 + i ] += tempi;
            data[ 546 + i ] += tempr2;
            data[ 547 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 512
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 544 ] * wr - data[ i + 545 ] * wi;
            uniform float tempi  = data[ i + 544 ] * wi + data[ i + 545 ] * wr;
            uniform float tempr2 = data[ i + 546 ] * wr2 - data[ i + 547 ] * wi2;
            uniform float tempi2 = data[ i + 546 ] * wi2 + data[ i + 547 ] * wr2;
            data[ i + 544 ] = data[ 512 + i ] - tempr;
            data[ i + 545 ] = data[ 513 + i ] - tempi;
            data[ i + 546 ] = data[ 514 + i ] - tempr2;
            data[ i + 547 ] = data[ 515 + i ] - tempi2;
            data[ 512 + i ] += tempr;
            data[ 513 + i ] += tempi;
            data[ 514 + i ] += tempr2;
            data[ 515 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 576
    {
        uniform float tr = data[578];
        uniform float ti = data[579];
        data[578] = data[576] - tr;
        data[579] = data[577] - ti;
        data[576] += tr;
        data[577] += ti;
        tr = data[582];
        ti = data[583];
        data[582] = data[581] - ti;
        data[583] = tr - data[580];
        data[580] += tr;
        data[581] += ti;
        tr = data[580];
        ti = data[581];
        data[580] = data[576] - tr;
        data[581] = data[577] - ti;
        data[576] += tr;
        data[577] += ti;
        tr = data[582];
        ti = data[583];
        data[582] = data[578] - tr;
        data[583] = data[579] - ti;
        data[578] += tr;
        data[579] += ti;
    }
    // N = 4, at 584
    {
        uniform float tr = data[586];
        uniform float ti = data[587];
        data[586] = data[584] - tr;
        data[587] = data[585] - ti;
        data[584] += tr;
        data[585] += ti;
        tr = data[590];
        ti = data[591];
        data[590] = data[589] - ti;
        data[591] = tr - data[588];
        data[588] += tr;
        data[589] += ti;
        tr = data[588];
        ti = data[589];
        data[588] = data[584] - tr;
        data[589] = data[585] - ti;
        data[584] += tr;
        data[585] += ti;
        tr = data[590];
        ti = data[591];
        data[590] = data[586] - tr;
        data[591] = data[587] - ti;
        data[586] += tr;
        data[587] += ti;
    }
    // N = 8, at 576
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 584 ] * wr - data[ i + 585 ] * wi;
            uniform float tempi  = data[ i + 584 ] * wi + data[ i + 585 ] * wr;
            uniform float tempr2 = data[ i + 586 ] * wr2 - data[ i + 587 ] * wi2;
            uniform float tempi2 = data[ i + 586 ] * wi2 + data[ i + 587 ] * wr2;
            data[ i + 584 ] = data[ 576 + i ] - tempr;
            data[ i + 585 ] = data[ 577 + i ] - tempi;
            data[ i + 586 ] = data[ 578 + i ] - tempr2;
            data[ i + 587 ] = data[ 579 + i ] - tempi2;
            data[ 576 + i ] += tempr;
            data[ 577 + i ] += tempi;
            data[ 578 + i ] += tempr2;
            data[ 579 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 592
    {
        uniform float tr = data[594];
        uniform float ti = data[595];
        data[594] = data[592] - tr;
        data[595] = data[593] - ti;
        data[592] += tr;
        data[593] += ti;
        tr = data[598];
        ti = data[599];
        data[598] = data[597] - ti;
        data[599] = tr - data[596];
        data[596] += tr;
        data[597] += ti;
        tr = data[596];
        ti = data[597];
        data[596] = data[592] - tr;
        data[597] = data[593] - ti;
        data[592] += tr;
        data[593] += ti;
        tr = data[598];
        ti = data[599];
        data[598] = data[594] - tr;
        data[599] = data[595] - ti;
        data[594] += tr;
        data[595] += ti;
    }
    // N = 4, at 600
    {
        uniform float tr = data[602];
        uniform float ti = data[603];
        data[602] = data[600] - tr;
        data[603] = data[601] - ti;
        data[600] += tr;
        data[601] += ti;
        tr = data[606];
        ti = data[607];
        data[606] = data[605] - ti;
        data[607] = tr - data[604];
        data[604] += tr;
        data[605] += ti;
        tr = data[604];
        ti = data[605];
        data[604] = data[600] - tr;
        data[605] = data[601] - ti;
        data[600] += tr;
        data[601] += ti;
        tr = data[606];
        ti = data[607];
        data[606] = data[602] - tr;
        data[607] = data[603] - ti;
        data[602] += tr;
        data[603] += ti;
    }
    // N = 8, at 592
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 600 ] * wr - data[ i + 601 ] * wi;
            uniform float tempi  = data[ i + 600 ] * wi + data[ i + 601 ] * wr;
            uniform float tempr2 = data[ i + 602 ] * wr2 - data[ i + 603 ] * wi2;
            uniform float tempi2 = data[ i + 602 ] * wi2 + data[ i + 603 ] * wr2;
            data[ i + 600 ] = data[ 592 + i ] - tempr;
            data[ i + 601 ] = data[ 593 + i ] - tempi;
            data[ i + 602 ] = data[ 594 + i ] - tempr2;
            data[ i + 603 ] = data[ 595 + i ] - tempi2;
            data[ 592 + i ] += tempr;
            data[ 593 + i ] += tempi;
            data[ 594 + i ] += tempr2;
            data[ 595 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 576
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 592 ] * wr - data[ i + 593 ] * wi;
            uniform float tempi  = data[ i + 592 ] * wi + data[ i + 593 ] * wr;
            uniform float tempr2 = data[ i + 594 ] * wr2 - data[ i + 595 ] * wi2;
            uniform float tempi2 = data[ i + 594 ] * wi2 + data[ i + 595 ] * wr2;
            data[ i + 592 ] = data[ 576 + i ] - tempr;
            data[ i + 593 ] = data[ 577 + i ] - tempi;
            data[ i + 594 ] = data[ 578 + i ] - tempr2;
            data[ i + 595 ] = data[ 579 + i ] - tempi2;
            data[ 576 + i ] += tempr;
            data[ 577 + i ] += tempi;
            data[ 578 + i ] += tempr2;
            data[ 579 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 608
    {
        uniform float tr = data[610];
        uniform float ti = data[611];
        data[610] = data[608] - tr;
        data[611] = data[609] - ti;
        data[608] += tr;
        data[609] += ti;
        tr = data[614];
        ti = data[615];
        data[614] = data[613] - ti;
        data[615] = tr - data[612];
        data[612] += tr;
        data[613] += ti;
        tr = data[612];
        ti = data[613];
        data[612] = data[608] - tr;
        data[613] = data[609] - ti;
        data[608] += tr;
        data[609] += ti;
        tr = data[614];
        ti = data[615];
        data[614] = data[610] - tr;
        data[615] = data[611] - ti;
        data[610] += tr;
        data[611] += ti;
    }
    // N = 4, at 616
    {
        uniform float tr = data[618];
        uniform float ti = data[619];
        data[618] = data[616] - tr;
        data[619] = data[617] - ti;
        data[616] += tr;
        data[617] += ti;
        tr = data[622];
        ti = data[623];
        data[622] = data[621] - ti;
        data[623] = tr - data[620];
        data[620] += tr;
        data[621] += ti;
        tr = data[620];
        ti = data[621];
        data[620] = data[616] - tr;
        data[621] = data[617] - ti;
        data[616] += tr;
        data[617] += ti;
        tr = data[622];
        ti = data[623];
        data[622] = data[618] - tr;
        data[623] = data[619] - ti;
        data[618] += tr;
        data[619] += ti;
    }
    // N = 8, at 608
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 616 ] * wr - data[ i + 617 ] * wi;
            uniform float tempi  = data[ i + 616 ] * wi + data[ i + 617 ] * wr;
            uniform float tempr2 = data[ i + 618 ] * wr2 - data[ i + 619 ] * wi2;
            uniform float tempi2 = data[ i + 618 ] * wi2 + data[ i + 619 ] * wr2;
            data[ i + 616 ] = data[ 608 + i ] - tempr;
            data[ i + 617 ] = data[ 609 + i ] - tempi;
            data[ i + 618 ] = data[ 610 + i ] - tempr2;
            data[ i + 619 ] = data[ 611 + i ] - tempi2;
            data[ 608 + i ] += tempr;
            data[ 609 + i ] += tempi;
            data[ 610 + i ] += tempr2;
            data[ 611 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 624
    {
        uniform float tr = data[626];
        uniform float ti = data[627];
        data[626] = data[624] - tr;
        data[627] = data[625] - ti;
        data[624] += tr;
        data[625] += ti;
        tr = data[630];
        ti = data[631];
        data[630] = data[629] - ti;
        data[631] = tr - data[628];
        data[628] += tr;
        data[629] += ti;
        tr = data[628];
        ti = data[629];
        data[628] = data[624] - tr;
        data[629] = data[625] - ti;
        data[624] += tr;
        data[625] += ti;
        tr = data[630];
        ti = data[631];
        data[630] = data[626] - tr;
        data[631] = data[627] - ti;
        data[626] += tr;
        data[627] += ti;
    }
    // N = 4, at 632
    {
        uniform float tr = data[634];
        uniform float ti = data[635];
        data[634] = data[632] - tr;
        data[635] = data[633] - ti;
        data[632] += tr;
        data[633] += ti;
        tr = data[638];
        ti = data[639];
        data[638] = data[637] - ti;
        data[639] = tr - data[636];
        data[636] += tr;
        data[637] += ti;
        tr = data[636];
        ti = data[637];
        data[636] = data[632] - tr;
        data[637] = data[633] - ti;
        data[632] += tr;
        data[633] += ti;
        tr = data[638];
        ti = data[639];
        data[638] = data[634] - tr;
        data[639] = data[635] - ti;
        data[634] += tr;
        data[635] += ti;
    }
    // N = 8, at 624
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 632 ] * wr - data[ i + 633 ] * wi;
            uniform float tempi  = data[ i + 632 ] * wi + data[ i + 633 ] * wr;
            uniform float tempr2 = data[ i + 634 ] * wr2 - data[ i + 635 ] * wi2;
            uniform float tempi2 = data[ i + 634 ] * wi2 + data[ i + 635 ] * wr2;
            data[ i + 632 ] = data[ 624 + i ] - tempr;
            data[ i + 633 ] = data[ 625 + i ] - tempi;
            data[ i + 634 ] = data[ 626 + i ] - tempr2;
            data[ i + 635 ] = data[ 627 + i ] - tempi2;
            data[ 624 + i ] += tempr;
            data[ 625 + i ] += tempi;
            data[ 626 + i ] += tempr2;
            data[ 627 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 608
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 624 ] * wr - data[ i + 625 ] * wi;
            uniform float tempi  = data[ i + 624 ] * wi + data[ i + 625 ] * wr;
            uniform float tempr2 = data[ i + 626 ] * wr2 - data[ i + 627 ] * wi2;
            uniform float tempi2 = data[ i + 626 ] * wi2 + data[ i + 627 ] * wr2;
            data[ i + 624 ] = data[ 608 + i ] - tempr;
            data[ i + 625 ] = data[ 609 + i ] - tempi;
            data[ i + 626 ] = data[ 610 + i ] - tempr2;
            data[ i + 627 ] = data[ 611 + i ] - tempi2;
            data[ 608 + i ] += tempr;
            data[ 609 + i ] += tempi;
            data[ 610 + i ] += tempr2;
            data[ 611 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 576
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 608 ] * wr - data[ i + 609 ] * wi;
            uniform float tempi  = data[ i + 608 ] * wi + data[ i + 609 ] * wr;
            uniform float tempr2 = data[ i + 610 ] * wr2 - data[ i + 611 ] * wi2;
            uniform float tempi2 = data[ i + 610 ] * wi2 + data[ i + 611 ] * wr2;
            data[ i + 608 ] = data[ 576 + i ] - tempr;
            data[ i + 609 ] = data[ 577 + i ] - tempi;
            data[ i + 610 ] = data[ 578 + i ] - tempr2;
            data[ i + 611 ] = data[ 579 + i ] - tempi2;
            data[ 576 + i ] += tempr;
            data[ 577 + i ] += tempi;
            data[ 578 + i ] += tempr2;
            data[ 579 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 512
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 576 ] * wr - data[ i + 577 ] * wi;
            uniform float tempi  = data[ i + 576 ] * wi + data[ i + 577 ] * wr;
            uniform float tempr2 = data[ i + 578 ] * wr2 - data[ i + 579 ] * wi2;
            uniform float tempi2 = data[ i + 578 ] * wi2 + data[ i + 579 ] * wr2;
            data[ i + 576 ] = data[ 512 + i ] - tempr;
            data[ i + 577 ] = data[ 513 + i ] - tempi;
            data[ i + 578 ] = data[ 514 + i ] - tempr2;
            data[ i + 579 ] = data[ 515 + i ] - tempi2;
            data[ 512 + i ] += tempr;
            data[ 513 + i ] += tempi;
            data[ 514 + i ] += tempr2;
            data[ 515 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 640
    {
        uniform float tr = data[642];
        uniform float ti = data[643];
        data[642] = data[640] - tr;
        data[643] = data[641] - ti;
        data[640] += tr;
        data[641] += ti;
        tr = data[646];
        ti = data[647];
        data[646] = data[645] - ti;
        data[647] = tr - data[644];
        data[644] += tr;
        data[645] += ti;
        tr = data[644];
        ti = data[645];
        data[644] = data[640] - tr;
        data[645] = data[641] - ti;
        data[640] += tr;
        data[641] += ti;
        tr = data[646];
        ti = data[647];
        data[646] = data[642] - tr;
        data[647] = data[643] - ti;
        data[642] += tr;
        data[643] += ti;
    }
    // N = 4, at 648
    {
        uniform float tr = data[650];
        uniform float ti = data[651];
        data[650] = data[648] - tr;
        data[651] = data[649] - ti;
        data[648] += tr;
        data[649] += ti;
        tr = data[654];
        ti = data[655];
        data[654] = data[653] - ti;
        data[655] = tr - data[652];
        data[652] += tr;
        data[653] += ti;
        tr = data[652];
        ti = data[653];
        data[652] = data[648] - tr;
        data[653] = data[649] - ti;
        data[648] += tr;
        data[649] += ti;
        tr = data[654];
        ti = data[655];
        data[654] = data[650] - tr;
        data[655] = data[651] - ti;
        data[650] += tr;
        data[651] += ti;
    }
    // N = 8, at 640
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 648 ] * wr - data[ i + 649 ] * wi;
            uniform float tempi  = data[ i + 648 ] * wi + data[ i + 649 ] * wr;
            uniform float tempr2 = data[ i + 650 ] * wr2 - data[ i + 651 ] * wi2;
            uniform float tempi2 = data[ i + 650 ] * wi2 + data[ i + 651 ] * wr2;
            data[ i + 648 ] = data[ 640 + i ] - tempr;
            data[ i + 649 ] = data[ 641 + i ] - tempi;
            data[ i + 650 ] = data[ 642 + i ] - tempr2;
            data[ i + 651 ] = data[ 643 + i ] - tempi2;
            data[ 640 + i ] += tempr;
            data[ 641 + i ] += tempi;
            data[ 642 + i ] += tempr2;
            data[ 643 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 656
    {
        uniform float tr = data[658];
        uniform float ti = data[659];
        data[658] = data[656] - tr;
        data[659] = data[657] - ti;
        data[656] += tr;
        data[657] += ti;
        tr = data[662];
        ti = data[663];
        data[662] = data[661] - ti;
        data[663] = tr - data[660];
        data[660] += tr;
        data[661] += ti;
        tr = data[660];
        ti = data[661];
        data[660] = data[656] - tr;
        data[661] = data[657] - ti;
        data[656] += tr;
        data[657] += ti;
        tr = data[662];
        ti = data[663];
        data[662] = data[658] - tr;
        data[663] = data[659] - ti;
        data[658] += tr;
        data[659] += ti;
    }
    // N = 4, at 664
    {
        uniform float tr = data[666];
        uniform float ti = data[667];
        data[666] = data[664] - tr;
        data[667] = data[665] - ti;
        data[664] += tr;
        data[665] += ti;
        tr = data[670];
        ti = data[671];
        data[670] = data[669] - ti;
        data[671] = tr - data[668];
        data[668] += tr;
        data[669] += ti;
        tr = data[668];
        ti = data[669];
        data[668] = data[664] - tr;
        data[669] = data[665] - ti;
        data[664] += tr;
        data[665] += ti;
        tr = data[670];
        ti = data[671];
        data[670] = data[666] - tr;
        data[671] = data[667] - ti;
        data[666] += tr;
        data[667] += ti;
    }
    // N = 8, at 656
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 664 ] * wr - data[ i + 665 ] * wi;
            uniform float tempi  = data[ i + 664 ] * wi + data[ i + 665 ] * wr;
            uniform float tempr2 = data[ i + 666 ] * wr2 - data[ i + 667 ] * wi2;
            uniform float tempi2 = data[ i + 666 ] * wi2 + data[ i + 667 ] * wr2;
            data[ i + 664 ] = data[ 656 + i ] - tempr;
            data[ i + 665 ] = data[ 657 + i ] - tempi;
            data[ i + 666 ] = data[ 658 + i ] - tempr2;
            data[ i + 667 ] = data[ 659 + i ] - tempi2;
            data[ 656 + i ] += tempr;
            data[ 657 + i ] += tempi;
            data[ 658 + i ] += tempr2;
            data[ 659 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 640
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 656 ] * wr - data[ i + 657 ] * wi;
            uniform float tempi  = data[ i + 656 ] * wi + data[ i + 657 ] * wr;
            uniform float tempr2 = data[ i + 658 ] * wr2 - data[ i + 659 ] * wi2;
            uniform float tempi2 = data[ i + 658 ] * wi2 + data[ i + 659 ] * wr2;
            data[ i + 656 ] = data[ 640 + i ] - tempr;
            data[ i + 657 ] = data[ 641 + i ] - tempi;
            data[ i + 658 ] = data[ 642 + i ] - tempr2;
            data[ i + 659 ] = data[ 643 + i ] - tempi2;
            data[ 640 + i ] += tempr;
            data[ 641 + i ] += tempi;
            data[ 642 + i ] += tempr2;
            data[ 643 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 672
    {
        uniform float tr = data[674];
        uniform float ti = data[675];
        data[674] = data[672] - tr;
        data[675] = data[673] - ti;
        data[672] += tr;
        data[673] += ti;
        tr = data[678];
        ti = data[679];
        data[678] = data[677] - ti;
        data[679] = tr - data[676];
        data[676] += tr;
        data[677] += ti;
        tr = data[676];
        ti = data[677];
        data[676] = data[672] - tr;
        data[677] = data[673] - ti;
        data[672] += tr;
        data[673] += ti;
        tr = data[678];
        ti = data[679];
        data[678] = data[674] - tr;
        data[679] = data[675] - ti;
        data[674] += tr;
        data[675] += ti;
    }
    // N = 4, at 680
    {
        uniform float tr = data[682];
        uniform float ti = data[683];
        data[682] = data[680] - tr;
        data[683] = data[681] - ti;
        data[680] += tr;
        data[681] += ti;
        tr = data[686];
        ti = data[687];
        data[686] = data[685] - ti;
        data[687] = tr - data[684];
        data[684] += tr;
        data[685] += ti;
        tr = data[684];
        ti = data[685];
        data[684] = data[680] - tr;
        data[685] = data[681] - ti;
        data[680] += tr;
        data[681] += ti;
        tr = data[686];
        ti = data[687];
        data[686] = data[682] - tr;
        data[687] = data[683] - ti;
        data[682] += tr;
        data[683] += ti;
    }
    // N = 8, at 672
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 680 ] * wr - data[ i + 681 ] * wi;
            uniform float tempi  = data[ i + 680 ] * wi + data[ i + 681 ] * wr;
            uniform float tempr2 = data[ i + 682 ] * wr2 - data[ i + 683 ] * wi2;
            uniform float tempi2 = data[ i + 682 ] * wi2 + data[ i + 683 ] * wr2;
            data[ i + 680 ] = data[ 672 + i ] - tempr;
            data[ i + 681 ] = data[ 673 + i ] - tempi;
            data[ i + 682 ] = data[ 674 + i ] - tempr2;
            data[ i + 683 ] = data[ 675 + i ] - tempi2;
            data[ 672 + i ] += tempr;
            data[ 673 + i ] += tempi;
            data[ 674 + i ] += tempr2;
            data[ 675 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 688
    {
        uniform float tr = data[690];
        uniform float ti = data[691];
        data[690] = data[688] - tr;
        data[691] = data[689] - ti;
        data[688] += tr;
        data[689] += ti;
        tr = data[694];
        ti = data[695];
        data[694] = data[693] - ti;
        data[695] = tr - data[692];
        data[692] += tr;
        data[693] += ti;
        tr = data[692];
        ti = data[693];
        data[692] = data[688] - tr;
        data[693] = data[689] - ti;
        data[688] += tr;
        data[689] += ti;
        tr = data[694];
        ti = data[695];
        data[694] = data[690] - tr;
        data[695] = data[691] - ti;
        data[690] += tr;
        data[691] += ti;
    }
    // N = 4, at 696
    {
        uniform float tr = data[698];
        uniform float ti = data[699];
        data[698] = data[696] - tr;
        data[699] = data[697] - ti;
        data[696] += tr;
        data[697] += ti;
        tr = data[702];
        ti = data[703];
        data[702] = data[701] - ti;
        data[703] = tr - data[700];
        data[700] += tr;
        data[701] += ti;
        tr = data[700];
        ti = data[701];
        data[700] = data[696] - tr;
        data[701] = data[697] - ti;
        data[696] += tr;
        data[697] += ti;
        tr = data[702];
        ti = data[703];
        data[702] = data[698] - tr;
        data[703] = data[699] - ti;
        data[698] += tr;
        data[699] += ti;
    }
    // N = 8, at 688
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 696 ] * wr - data[ i + 697 ] * wi;
            uniform float tempi  = data[ i + 696 ] * wi + data[ i + 697 ] * wr;
            uniform float tempr2 = data[ i + 698 ] * wr2 - data[ i + 699 ] * wi2;
            uniform float tempi2 = data[ i + 698 ] * wi2 + data[ i + 699 ] * wr2;
            data[ i + 696 ] = data[ 688 + i ] - tempr;
            data[ i + 697 ] = data[ 689 + i ] - tempi;
            data[ i + 698 ] = data[ 690 + i ] - tempr2;
            data[ i + 699 ] = data[ 691 + i ] - tempi2;
            data[ 688 + i ] += tempr;
            data[ 689 + i ] += tempi;
            data[ 690 + i ] += tempr2;
            data[ 691 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 672
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 688 ] * wr - data[ i + 689 ] * wi;
            uniform float tempi  = data[ i + 688 ] * wi + data[ i + 689 ] * wr;
            uniform float tempr2 = data[ i + 690 ] * wr2 - data[ i + 691 ] * wi2;
            uniform float tempi2 = data[ i + 690 ] * wi2 + data[ i + 691 ] * wr2;
            data[ i + 688 ] = data[ 672 + i ] - tempr;
            data[ i + 689 ] = data[ 673 + i ] - tempi;
            data[ i + 690 ] = data[ 674 + i ] - tempr2;
            data[ i + 691 ] = data[ 675 + i ] - tempi2;
            data[ 672 + i ] += tempr;
            data[ 673 + i ] += tempi;
            data[ 674 + i ] += tempr2;
            data[ 675 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 640
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 672 ] * wr - data[ i + 673 ] * wi;
            uniform float tempi  = data[ i + 672 ] * wi + data[ i + 673 ] * wr;
            uniform float tempr2 = data[ i + 674 ] * wr2 - data[ i + 675 ] * wi2;
            uniform float tempi2 = data[ i + 674 ] * wi2 + data[ i + 675 ] * wr2;
            data[ i + 672 ] = data[ 640 + i ] - tempr;
            data[ i + 673 ] = data[ 641 + i ] - tempi;
            data[ i + 674 ] = data[ 642 + i ] - tempr2;
            data[ i + 675 ] = data[ 643 + i ] - tempi2;
            data[ 640 + i ] += tempr;
            data[ 641 + i ] += tempi;
            data[ 642 + i ] += tempr2;
            data[ 643 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 704
    {
        uniform float tr = data[706];
        uniform float ti = data[707];
        data[706] = data[704] - tr;
        data[707] = data[705] - ti;
        data[704] += tr;
        data[705] += ti;
        tr = data[710];
        ti = data[711];
        data[710] = data[709] - ti;
        data[711] = tr - data[708];
        data[708] += tr;
        data[709] += ti;
        tr = data[708];
        ti = data[709];
        data[708] = data[704] - tr;
        data[709] = data[705] - ti;
        data[704] += tr;
        data[705] += ti;
        tr = data[710];
        ti = data[711];
        data[710] = data[706] - tr;
        data[711] = data[707] - ti;
        data[706] += tr;
        data[707] += ti;
    }
    // N = 4, at 712
    {
        uniform float tr = data[714];
        uniform float ti = data[715];
        data[714] = data[712] - tr;
        data[715] = data[713] - ti;
        data[712] += tr;
        data[713] += ti;
        tr = data[718];
        ti = data[719];
        data[718] = data[717] - ti;
        data[719] = tr - data[716];
        data[716] += tr;
        data[717] += ti;
        tr = data[716];
        ti = data[717];
        data[716] = data[712] - tr;
        data[717] = data[713] - ti;
        data[712] += tr;
        data[713] += ti;
        tr = data[718];
        ti = data[719];
        data[718] = data[714] - tr;
        data[719] = data[715] - ti;
        data[714] += tr;
        data[715] += ti;
    }
    // N = 8, at 704
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 712 ] * wr - data[ i + 713 ] * wi;
            uniform float tempi  = data[ i + 712 ] * wi + data[ i + 713 ] * wr;
            uniform float tempr2 = data[ i + 714 ] * wr2 - data[ i + 715 ] * wi2;
            uniform float tempi2 = data[ i + 714 ] * wi2 + data[ i + 715 ] * wr2;
            data[ i + 712 ] = data[ 704 + i ] - tempr;
            data[ i + 713 ] = data[ 705 + i ] - tempi;
            data[ i + 714 ] = data[ 706 + i ] - tempr2;
            data[ i + 715 ] = data[ 707 + i ] - tempi2;
            data[ 704 + i ] += tempr;
            data[ 705 + i ] += tempi;
            data[ 706 + i ] += tempr2;
            data[ 707 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 720
    {
        uniform float tr = data[722];
        uniform float ti = data[723];
        data[722] = data[720] - tr;
        data[723] = data[721] - ti;
        data[720] += tr;
        data[721] += ti;
        tr = data[726];
        ti = data[727];
        data[726] = data[725] - ti;
        data[727] = tr - data[724];
        data[724] += tr;
        data[725] += ti;
        tr = data[724];
        ti = data[725];
        data[724] = data[720] - tr;
        data[725] = data[721] - ti;
        data[720] += tr;
        data[721] += ti;
        tr = data[726];
        ti = data[727];
        data[726] = data[722] - tr;
        data[727] = data[723] - ti;
        data[722] += tr;
        data[723] += ti;
    }
    // N = 4, at 728
    {
        uniform float tr = data[730];
        uniform float ti = data[731];
        data[730] = data[728] - tr;
        data[731] = data[729] - ti;
        data[728] += tr;
        data[729] += ti;
        tr = data[734];
        ti = data[735];
        data[734] = data[733] - ti;
        data[735] = tr - data[732];
        data[732] += tr;
        data[733] += ti;
        tr = data[732];
        ti = data[733];
        data[732] = data[728] - tr;
        data[733] = data[729] - ti;
        data[728] += tr;
        data[729] += ti;
        tr = data[734];
        ti = data[735];
        data[734] = data[730] - tr;
        data[735] = data[731] - ti;
        data[730] += tr;
        data[731] += ti;
    }
    // N = 8, at 720
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 728 ] * wr - data[ i + 729 ] * wi;
            uniform float tempi  = data[ i + 728 ] * wi + data[ i + 729 ] * wr;
            uniform float tempr2 = data[ i + 730 ] * wr2 - data[ i + 731 ] * wi2;
            uniform float tempi2 = data[ i + 730 ] * wi2 + data[ i + 731 ] * wr2;
            data[ i + 728 ] = data[ 720 + i ] - tempr;
            data[ i + 729 ] = data[ 721 + i ] - tempi;
            data[ i + 730 ] = data[ 722 + i ] - tempr2;
            data[ i + 731 ] = data[ 723 + i ] - tempi2;
            data[ 720 + i ] += tempr;
            data[ 721 + i ] += tempi;
            data[ 722 + i ] += tempr2;
            data[ 723 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 704
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 720 ] * wr - data[ i + 721 ] * wi;
            uniform float tempi  = data[ i + 720 ] * wi + data[ i + 721 ] * wr;
            uniform float tempr2 = data[ i + 722 ] * wr2 - data[ i + 723 ] * wi2;
            uniform float tempi2 = data[ i + 722 ] * wi2 + data[ i + 723 ] * wr2;
            data[ i + 720 ] = data[ 704 + i ] - tempr;
            data[ i + 721 ] = data[ 705 + i ] - tempi;
            data[ i + 722 ] = data[ 706 + i ] - tempr2;
            data[ i + 723 ] = data[ 707 + i ] - tempi2;
            data[ 704 + i ] += tempr;
            data[ 705 + i ] += tempi;
            data[ 706 + i ] += tempr2;
            data[ 707 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 736
    {
        uniform float tr = data[738];
        uniform float ti = data[739];
        data[738] = data[736] - tr;
        data[739] = data[737] - ti;
        data[736] += tr;
        data[737] += ti;
        tr = data[742];
        ti = data[743];
        data[742] = data[741] - ti;
        data[743] = tr - data[740];
        data[740] += tr;
        data[741] += ti;
        tr = data[740];
        ti = data[741];
        data[740] = data[736] - tr;
        data[741] = data[737] - ti;
        data[736] += tr;
        data[737] += ti;
        tr = data[742];
        ti = data[743];
        data[742] = data[738] - tr;
        data[743] = data[739] - ti;
        data[738] += tr;
        data[739] += ti;
    }
    // N = 4, at 744
    {
        uniform float tr = data[746];
        uniform float ti = data[747];
        data[746] = data[744] - tr;
        data[747] = data[745] - ti;
        data[744] += tr;
        data[745] += ti;
        tr = data[750];
        ti = data[751];
        data[750] = data[749] - ti;
        data[751] = tr - data[748];
        data[748] += tr;
        data[749] += ti;
        tr = data[748];
        ti = data[749];
        data[748] = data[744] - tr;
        data[749] = data[745] - ti;
        data[744] += tr;
        data[745] += ti;
        tr = data[750];
        ti = data[751];
        data[750] = data[746] - tr;
        data[751] = data[747] - ti;
        data[746] += tr;
        data[747] += ti;
    }
    // N = 8, at 736
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 744 ] * wr - data[ i + 745 ] * wi;
            uniform float tempi  = data[ i + 744 ] * wi + data[ i + 745 ] * wr;
            uniform float tempr2 = data[ i + 746 ] * wr2 - data[ i + 747 ] * wi2;
            uniform float tempi2 = data[ i + 746 ] * wi2 + data[ i + 747 ] * wr2;
            data[ i + 744 ] = data[ 736 + i ] - tempr;
            data[ i + 745 ] = data[ 737 + i ] - tempi;
            data[ i + 746 ] = data[ 738 + i ] - tempr2;
            data[ i + 747 ] = data[ 739 + i ] - tempi2;
            data[ 736 + i ] += tempr;
            data[ 737 + i ] += tempi;
            data[ 738 + i ] += tempr2;
            data[ 739 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 752
    {
        uniform float tr = data[754];
        uniform float ti = data[755];
        data[754] = data[752] - tr;
        data[755] = data[753] - ti;
        data[752] += tr;
        data[753] += ti;
        tr = data[758];
        ti = data[759];
        data[758] = data[757] - ti;
        data[759] = tr - data[756];
        data[756] += tr;
        data[757] += ti;
        tr = data[756];
        ti = data[757];
        data[756] = data[752] - tr;
        data[757] = data[753] - ti;
        data[752] += tr;
        data[753] += ti;
        tr = data[758];
        ti = data[759];
        data[758] = data[754] - tr;
        data[759] = data[755] - ti;
        data[754] += tr;
        data[755] += ti;
    }
    // N = 4, at 760
    {
        uniform float tr = data[762];
        uniform float ti = data[763];
        data[762] = data[760] - tr;
        data[763] = data[761] - ti;
        data[760] += tr;
        data[761] += ti;
        tr = data[766];
        ti = data[767];
        data[766] = data[765] - ti;
        data[767] = tr - data[764];
        data[764] += tr;
        data[765] += ti;
        tr = data[764];
        ti = data[765];
        data[764] = data[760] - tr;
        data[765] = data[761] - ti;
        data[760] += tr;
        data[761] += ti;
        tr = data[766];
        ti = data[767];
        data[766] = data[762] - tr;
        data[767] = data[763] - ti;
        data[762] += tr;
        data[763] += ti;
    }
    // N = 8, at 752
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 760 ] * wr - data[ i + 761 ] * wi;
            uniform float tempi  = data[ i + 760 ] * wi + data[ i + 761 ] * wr;
            uniform float tempr2 = data[ i + 762 ] * wr2 - data[ i + 763 ] * wi2;
            uniform float tempi2 = data[ i + 762 ] * wi2 + data[ i + 763 ] * wr2;
            data[ i + 760 ] = data[ 752 + i ] - tempr;
            data[ i + 761 ] = data[ 753 + i ] - tempi;
            data[ i + 762 ] = data[ 754 + i ] - tempr2;
            data[ i + 763 ] = data[ 755 + i ] - tempi2;
            data[ 752 + i ] += tempr;
            data[ 753 + i ] += tempi;
            data[ 754 + i ] += tempr2;
            data[ 755 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 736
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 752 ] * wr - data[ i + 753 ] * wi;
            uniform float tempi  = data[ i + 752 ] * wi + data[ i + 753 ] * wr;
            uniform float tempr2 = data[ i + 754 ] * wr2 - data[ i + 755 ] * wi2;
            uniform float tempi2 = data[ i + 754 ] * wi2 + data[ i + 755 ] * wr2;
            data[ i + 752 ] = data[ 736 + i ] - tempr;
            data[ i + 753 ] = data[ 737 + i ] - tempi;
            data[ i + 754 ] = data[ 738 + i ] - tempr2;
            data[ i + 755 ] = data[ 739 + i ] - tempi2;
            data[ 736 + i ] += tempr;
            data[ 737 + i ] += tempi;
            data[ 738 + i ] += tempr2;
            data[ 739 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 704
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 736 ] * wr - data[ i + 737 ] * wi;
            uniform float tempi  = data[ i + 736 ] * wi + data[ i + 737 ] * wr;
            uniform float tempr2 = data[ i + 738 ] * wr2 - data[ i + 739 ] * wi2;
            uniform float tempi2 = data[ i + 738 ] * wi2 + data[ i + 739 ] * wr2;
            data[ i + 736 ] = data[ 704 + i ] - tempr;
            data[ i + 737 ] = data[ 705 + i ] - tempi;
            data[ i + 738 ] = data[ 706 + i ] - tempr2;
            data[ i + 739 ] = data[ 707 + i ] - tempi2;
            data[ 704 + i ] += tempr;
            data[ 705 + i ] += tempi;
            data[ 706 + i ] += tempr2;
            data[ 707 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 640
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 704 ] * wr - data[ i + 705 ] * wi;
            uniform float tempi  = data[ i + 704 ] * wi + data[ i + 705 ] * wr;
            uniform float tempr2 = data[ i + 706 ] * wr2 - data[ i + 707 ] * wi2;
            uniform float tempi2 = data[ i + 706 ] * wi2 + data[ i + 707 ] * wr2;
            data[ i + 704 ] = data[ 640 + i ] - tempr;
            data[ i + 705 ] = data[ 641 + i ] - tempi;
            data[ i + 706 ] = data[ 642 + i ] - tempr2;
            data[ i + 707 ] = data[ 643 + i ] - tempi2;
            data[ 640 + i ] += tempr;
            data[ 641 + i ] += tempi;
            data[ 642 + i ] += tempr2;
            data[ 643 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 512
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 640 ] * wr - data[ i + 641 ] * wi;
            uniform float tempi  = data[ i + 640 ] * wi + data[ i + 641 ] * wr;
            uniform float tempr2 = data[ i + 642 ] * wr2 - data[ i + 643 ] * wi2;
            uniform float tempi2 = data[ i + 642 ] * wi2 + data[ i + 643 ] * wr2;
            data[ i + 640 ] = data[ 512 + i ] - tempr;
            data[ i + 641 ] = data[ 513 + i ] - tempi;
            data[ i + 642 ] = data[ 514 + i ] - tempr2;
            data[ i + 643 ] = data[ 515 + i ] - tempi2;
            data[ 512 + i ] += tempr;
            data[ 513 + i ] += tempi;
            data[ 514 + i ] += tempr2;
            data[ 515 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 768
    {
        uniform float tr = data[770];
        uniform float ti = data[771];
        data[770] = data[768] - tr;
        data[771] = data[769] - ti;
        data[768] += tr;
        data[769] += ti;
        tr = data[774];
        ti = data[775];
        data[774] = data[773] - ti;
        data[775] = tr - data[772];
        data[772] += tr;
        data[773] += ti;
        tr = data[772];
        ti = data[773];
        data[772] = data[768] - tr;
        data[773] = data[769] - ti;
        data[768] += tr;
        data[769] += ti;
        tr = data[774];
        ti = data[775];
        data[774] = data[770] - tr;
        data[775] = data[771] - ti;
        data[770] += tr;
        data[771] += ti;
    }
    // N = 4, at 776
    {
        uniform float tr = data[778];
        uniform float ti = data[779];
        data[778] = data[776] - tr;
        data[779] = data[777] - ti;
        data[776] += tr;
        data[777] += ti;
        tr = data[782];
        ti = data[783];
        data[782] = data[781] - ti;
        data[783] = tr - data[780];
        data[780] += tr;
        data[781] += ti;
        tr = data[780];
        ti = data[781];
        data[780] = data[776] - tr;
        data[781] = data[777] - ti;
        data[776] += tr;
        data[777] += ti;
        tr = data[782];
        ti = data[783];
        data[782] = data[778] - tr;
        data[783] = data[779] - ti;
        data[778] += tr;
        data[779] += ti;
    }
    // N = 8, at 768
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 776 ] * wr - data[ i + 777 ] * wi;
            uniform float tempi  = data[ i + 776 ] * wi + data[ i + 777 ] * wr;
            uniform float tempr2 = data[ i + 778 ] * wr2 - data[ i + 779 ] * wi2;
            uniform float tempi2 = data[ i + 778 ] * wi2 + data[ i + 779 ] * wr2;
            data[ i + 776 ] = data[ 768 + i ] - tempr;
            data[ i + 777 ] = data[ 769 + i ] - tempi;
            data[ i + 778 ] = data[ 770 + i ] - tempr2;
            data[ i + 779 ] = data[ 771 + i ] - tempi2;
            data[ 768 + i ] += tempr;
            data[ 769 + i ] += tempi;
            data[ 770 + i ] += tempr2;
            data[ 771 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 784
    {
        uniform float tr = data[786];
        uniform float ti = data[787];
        data[786] = data[784] - tr;
        data[787] = data[785] - ti;
        data[784] += tr;
        data[785] += ti;
        tr = data[790];
        ti = data[791];
        data[790] = data[789] - ti;
        data[791] = tr - data[788];
        data[788] += tr;
        data[789] += ti;
        tr = data[788];
        ti = data[789];
        data[788] = data[784] - tr;
        data[789] = data[785] - ti;
        data[784] += tr;
        data[785] += ti;
        tr = data[790];
        ti = data[791];
        data[790] = data[786] - tr;
        data[791] = data[787] - ti;
        data[786] += tr;
        data[787] += ti;
    }
    // N = 4, at 792
    {
        uniform float tr = data[794];
        uniform float ti = data[795];
        data[794] = data[792] - tr;
        data[795] = data[793] - ti;
        data[792] += tr;
        data[793] += ti;
        tr = data[798];
        ti = data[799];
        data[798] = data[797] - ti;
        data[799] = tr - data[796];
        data[796] += tr;
        data[797] += ti;
        tr = data[796];
        ti = data[797];
        data[796] = data[792] - tr;
        data[797] = data[793] - ti;
        data[792] += tr;
        data[793] += ti;
        tr = data[798];
        ti = data[799];
        data[798] = data[794] - tr;
        data[799] = data[795] - ti;
        data[794] += tr;
        data[795] += ti;
    }
    // N = 8, at 784
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 792 ] * wr - data[ i + 793 ] * wi;
            uniform float tempi  = data[ i + 792 ] * wi + data[ i + 793 ] * wr;
            uniform float tempr2 = data[ i + 794 ] * wr2 - data[ i + 795 ] * wi2;
            uniform float tempi2 = data[ i + 794 ] * wi2 + data[ i + 795 ] * wr2;
            data[ i + 792 ] = data[ 784 + i ] - tempr;
            data[ i + 793 ] = data[ 785 + i ] - tempi;
            data[ i + 794 ] = data[ 786 + i ] - tempr2;
            data[ i + 795 ] = data[ 787 + i ] - tempi2;
            data[ 784 + i ] += tempr;
            data[ 785 + i ] += tempi;
            data[ 786 + i ] += tempr2;
            data[ 787 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 768
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 784 ] * wr - data[ i + 785 ] * wi;
            uniform float tempi  = data[ i + 784 ] * wi + data[ i + 785 ] * wr;
            uniform float tempr2 = data[ i + 786 ] * wr2 - data[ i + 787 ] * wi2;
            uniform float tempi2 = data[ i + 786 ] * wi2 + data[ i + 787 ] * wr2;
            data[ i + 784 ] = data[ 768 + i ] - tempr;
            data[ i + 785 ] = data[ 769 + i ] - tempi;
            data[ i + 786 ] = data[ 770 + i ] - tempr2;
            data[ i + 787 ] = data[ 771 + i ] - tempi2;
            data[ 768 + i ] += tempr;
            data[ 769 + i ] += tempi;
            data[ 770 + i ] += tempr2;
            data[ 771 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 800
    {
        uniform float tr = data[802];
        uniform float ti = data[803];
        data[802] = data[800] - tr;
        data[803] = data[801] - ti;
        data[800] += tr;
        data[801] += ti;
        tr = data[806];
        ti = data[807];
        data[806] = data[805] - ti;
        data[807] = tr - data[804];
        data[804] += tr;
        data[805] += ti;
        tr = data[804];
        ti = data[805];
        data[804] = data[800] - tr;
        data[805] = data[801] - ti;
        data[800] += tr;
        data[801] += ti;
        tr = data[806];
        ti = data[807];
        data[806] = data[802] - tr;
        data[807] = data[803] - ti;
        data[802] += tr;
        data[803] += ti;
    }
    // N = 4, at 808
    {
        uniform float tr = data[810];
        uniform float ti = data[811];
        data[810] = data[808] - tr;
        data[811] = data[809] - ti;
        data[808] += tr;
        data[809] += ti;
        tr = data[814];
        ti = data[815];
        data[814] = data[813] - ti;
        data[815] = tr - data[812];
        data[812] += tr;
        data[813] += ti;
        tr = data[812];
        ti = data[813];
        data[812] = data[808] - tr;
        data[813] = data[809] - ti;
        data[808] += tr;
        data[809] += ti;
        tr = data[814];
        ti = data[815];
        data[814] = data[810] - tr;
        data[815] = data[811] - ti;
        data[810] += tr;
        data[811] += ti;
    }
    // N = 8, at 800
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 808 ] * wr - data[ i + 809 ] * wi;
            uniform float tempi  = data[ i + 808 ] * wi + data[ i + 809 ] * wr;
            uniform float tempr2 = data[ i + 810 ] * wr2 - data[ i + 811 ] * wi2;
            uniform float tempi2 = data[ i + 810 ] * wi2 + data[ i + 811 ] * wr2;
            data[ i + 808 ] = data[ 800 + i ] - tempr;
            data[ i + 809 ] = data[ 801 + i ] - tempi;
            data[ i + 810 ] = data[ 802 + i ] - tempr2;
            data[ i + 811 ] = data[ 803 + i ] - tempi2;
            data[ 800 + i ] += tempr;
            data[ 801 + i ] += tempi;
            data[ 802 + i ] += tempr2;
            data[ 803 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 816
    {
        uniform float tr = data[818];
        uniform float ti = data[819];
        data[818] = data[816] - tr;
        data[819] = data[817] - ti;
        data[816] += tr;
        data[817] += ti;
        tr = data[822];
        ti = data[823];
        data[822] = data[821] - ti;
        data[823] = tr - data[820];
        data[820] += tr;
        data[821] += ti;
        tr = data[820];
        ti = data[821];
        data[820] = data[816] - tr;
        data[821] = data[817] - ti;
        data[816] += tr;
        data[817] += ti;
        tr = data[822];
        ti = data[823];
        data[822] = data[818] - tr;
        data[823] = data[819] - ti;
        data[818] += tr;
        data[819] += ti;
    }
    // N = 4, at 824
    {
        uniform float tr = data[826];
        uniform float ti = data[827];
        data[826] = data[824] - tr;
        data[827] = data[825] - ti;
        data[824] += tr;
        data[825] += ti;
        tr = data[830];
        ti = data[831];
        data[830] = data[829] - ti;
        data[831] = tr - data[828];
        data[828] += tr;
        data[829] += ti;
        tr = data[828];
        ti = data[829];
        data[828] = data[824] - tr;
        data[829] = data[825] - ti;
        data[824] += tr;
        data[825] += ti;
        tr = data[830];
        ti = data[831];
        data[830] = data[826] - tr;
        data[831] = data[827] - ti;
        data[826] += tr;
        data[827] += ti;
    }
    // N = 8, at 816
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 824 ] * wr - data[ i + 825 ] * wi;
            uniform float tempi  = data[ i + 824 ] * wi + data[ i + 825 ] * wr;
            uniform float tempr2 = data[ i + 826 ] * wr2 - data[ i + 827 ] * wi2;
            uniform float tempi2 = data[ i + 826 ] * wi2 + data[ i + 827 ] * wr2;
            data[ i + 824 ] = data[ 816 + i ] - tempr;
            data[ i + 825 ] = data[ 817 + i ] - tempi;
            data[ i + 826 ] = data[ 818 + i ] - tempr2;
            data[ i + 827 ] = data[ 819 + i ] - tempi2;
            data[ 816 + i ] += tempr;
            data[ 817 + i ] += tempi;
            data[ 818 + i ] += tempr2;
            data[ 819 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 800
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 816 ] * wr - data[ i + 817 ] * wi;
            uniform float tempi  = data[ i + 816 ] * wi + data[ i + 817 ] * wr;
            uniform float tempr2 = data[ i + 818 ] * wr2 - data[ i + 819 ] * wi2;
            uniform float tempi2 = data[ i + 818 ] * wi2 + data[ i + 819 ] * wr2;
            data[ i + 816 ] = data[ 800 + i ] - tempr;
            data[ i + 817 ] = data[ 801 + i ] - tempi;
            data[ i + 818 ] = data[ 802 + i ] - tempr2;
            data[ i + 819 ] = data[ 803 + i ] - tempi2;
            data[ 800 + i ] += tempr;
            data[ 801 + i ] += tempi;
            data[ 802 + i ] += tempr2;
            data[ 803 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 768
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 800 ] * wr - data[ i + 801 ] * wi;
            uniform float tempi  = data[ i + 800 ] * wi + data[ i + 801 ] * wr;
            uniform float tempr2 = data[ i + 802 ] * wr2 - data[ i + 803 ] * wi2;
            uniform float tempi2 = data[ i + 802 ] * wi2 + data[ i + 803 ] * wr2;
            data[ i + 800 ] = data[ 768 + i ] - tempr;
            data[ i + 801 ] = data[ 769 + i ] - tempi;
            data[ i + 802 ] = data[ 770 + i ] - tempr2;
            data[ i + 803 ] = data[ 771 + i ] - tempi2;
            data[ 768 + i ] += tempr;
            data[ 769 + i ] += tempi;
            data[ 770 + i ] += tempr2;
            data[ 771 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 832
    {
        uniform float tr = data[834];
        uniform float ti = data[835];
        data[834] = data[832] - tr;
        data[835] = data[833] - ti;
        data[832] += tr;
        data[833] += ti;
        tr = data[838];
        ti = data[839];
        data[838] = data[837] - ti;
        data[839] = tr - data[836];
        data[836] += tr;
        data[837] += ti;
        tr = data[836];
        ti = data[837];
        data[836] = data[832] - tr;
        data[837] = data[833] - ti;
        data[832] += tr;
        data[833] += ti;
        tr = data[838];
        ti = data[839];
        data[838] = data[834] - tr;
        data[839] = data[835] - ti;
        data[834] += tr;
        data[835] += ti;
    }
    // N = 4, at 840
    {
        uniform float tr = data[842];
        uniform float ti = data[843];
        data[842] = data[840] - tr;
        data[843] = data[841] - ti;
        data[840] += tr;
        data[841] += ti;
        tr = data[846];
        ti = data[847];
        data[846] = data[845] - ti;
        data[847] = tr - data[844];
        data[844] += tr;
        data[845] += ti;
        tr = data[844];
        ti = data[845];
        data[844] = data[840] - tr;
        data[845] = data[841] - ti;
        data[840] += tr;
        data[841] += ti;
        tr = data[846];
        ti = data[847];
        data[846] = data[842] - tr;
        data[847] = data[843] - ti;
        data[842] += tr;
        data[843] += ti;
    }
    // N = 8, at 832
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 840 ] * wr - data[ i + 841 ] * wi;
            uniform float tempi  = data[ i + 840 ] * wi + data[ i + 841 ] * wr;
            uniform float tempr2 = data[ i + 842 ] * wr2 - data[ i + 843 ] * wi2;
            uniform float tempi2 = data[ i + 842 ] * wi2 + data[ i + 843 ] * wr2;
            data[ i + 840 ] = data[ 832 + i ] - tempr;
            data[ i + 841 ] = data[ 833 + i ] - tempi;
            data[ i + 842 ] = data[ 834 + i ] - tempr2;
            data[ i + 843 ] = data[ 835 + i ] - tempi2;
            data[ 832 + i ] += tempr;
            data[ 833 + i ] += tempi;
            data[ 834 + i ] += tempr2;
            data[ 835 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 848
    {
        uniform float tr = data[850];
        uniform float ti = data[851];
        data[850] = data[848] - tr;
        data[851] = data[849] - ti;
        data[848] += tr;
        data[849] += ti;
        tr = data[854];
        ti = data[855];
        data[854] = data[853] - ti;
        data[855] = tr - data[852];
        data[852] += tr;
        data[853] += ti;
        tr = data[852];
        ti = data[853];
        data[852] = data[848] - tr;
        data[853] = data[849] - ti;
        data[848] += tr;
        data[849] += ti;
        tr = data[854];
        ti = data[855];
        data[854] = data[850] - tr;
        data[855] = data[851] - ti;
        data[850] += tr;
        data[851] += ti;
    }
    // N = 4, at 856
    {
        uniform float tr = data[858];
        uniform float ti = data[859];
        data[858] = data[856] - tr;
        data[859] = data[857] - ti;
        data[856] += tr;
        data[857] += ti;
        tr = data[862];
        ti = data[863];
        data[862] = data[861] - ti;
        data[863] = tr - data[860];
        data[860] += tr;
        data[861] += ti;
        tr = data[860];
        ti = data[861];
        data[860] = data[856] - tr;
        data[861] = data[857] - ti;
        data[856] += tr;
        data[857] += ti;
        tr = data[862];
        ti = data[863];
        data[862] = data[858] - tr;
        data[863] = data[859] - ti;
        data[858] += tr;
        data[859] += ti;
    }
    // N = 8, at 848
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 856 ] * wr - data[ i + 857 ] * wi;
            uniform float tempi  = data[ i + 856 ] * wi + data[ i + 857 ] * wr;
            uniform float tempr2 = data[ i + 858 ] * wr2 - data[ i + 859 ] * wi2;
            uniform float tempi2 = data[ i + 858 ] * wi2 + data[ i + 859 ] * wr2;
            data[ i + 856 ] = data[ 848 + i ] - tempr;
            data[ i + 857 ] = data[ 849 + i ] - tempi;
            data[ i + 858 ] = data[ 850 + i ] - tempr2;
            data[ i + 859 ] = data[ 851 + i ] - tempi2;
            data[ 848 + i ] += tempr;
            data[ 849 + i ] += tempi;
            data[ 850 + i ] += tempr2;
            data[ 851 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 832
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 848 ] * wr - data[ i + 849 ] * wi;
            uniform float tempi  = data[ i + 848 ] * wi + data[ i + 849 ] * wr;
            uniform float tempr2 = data[ i + 850 ] * wr2 - data[ i + 851 ] * wi2;
            uniform float tempi2 = data[ i + 850 ] * wi2 + data[ i + 851 ] * wr2;
            data[ i + 848 ] = data[ 832 + i ] - tempr;
            data[ i + 849 ] = data[ 833 + i ] - tempi;
            data[ i + 850 ] = data[ 834 + i ] - tempr2;
            data[ i + 851 ] = data[ 835 + i ] - tempi2;
            data[ 832 + i ] += tempr;
            data[ 833 + i ] += tempi;
            data[ 834 + i ] += tempr2;
            data[ 835 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 864
    {
        uniform float tr = data[866];
        uniform float ti = data[867];
        data[866] = data[864] - tr;
        data[867] = data[865] - ti;
        data[864] += tr;
        data[865] += ti;
        tr = data[870];
        ti = data[871];
        data[870] = data[869] - ti;
        data[871] = tr - data[868];
        data[868] += tr;
        data[869] += ti;
        tr = data[868];
        ti = data[869];
        data[868] = data[864] - tr;
        data[869] = data[865] - ti;
        data[864] += tr;
        data[865] += ti;
        tr = data[870];
        ti = data[871];
        data[870] = data[866] - tr;
        data[871] = data[867] - ti;
        data[866] += tr;
        data[867] += ti;
    }
    // N = 4, at 872
    {
        uniform float tr = data[874];
        uniform float ti = data[875];
        data[874] = data[872] - tr;
        data[875] = data[873] - ti;
        data[872] += tr;
        data[873] += ti;
        tr = data[878];
        ti = data[879];
        data[878] = data[877] - ti;
        data[879] = tr - data[876];
        data[876] += tr;
        data[877] += ti;
        tr = data[876];
        ti = data[877];
        data[876] = data[872] - tr;
        data[877] = data[873] - ti;
        data[872] += tr;
        data[873] += ti;
        tr = data[878];
        ti = data[879];
        data[878] = data[874] - tr;
        data[879] = data[875] - ti;
        data[874] += tr;
        data[875] += ti;
    }
    // N = 8, at 864
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 872 ] * wr - data[ i + 873 ] * wi;
            uniform float tempi  = data[ i + 872 ] * wi + data[ i + 873 ] * wr;
            uniform float tempr2 = data[ i + 874 ] * wr2 - data[ i + 875 ] * wi2;
            uniform float tempi2 = data[ i + 874 ] * wi2 + data[ i + 875 ] * wr2;
            data[ i + 872 ] = data[ 864 + i ] - tempr;
            data[ i + 873 ] = data[ 865 + i ] - tempi;
            data[ i + 874 ] = data[ 866 + i ] - tempr2;
            data[ i + 875 ] = data[ 867 + i ] - tempi2;
            data[ 864 + i ] += tempr;
            data[ 865 + i ] += tempi;
            data[ 866 + i ] += tempr2;
            data[ 867 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 880
    {
        uniform float tr = data[882];
        uniform float ti = data[883];
        data[882] = data[880] - tr;
        data[883] = data[881] - ti;
        data[880] += tr;
        data[881] += ti;
        tr = data[886];
        ti = data[887];
        data[886] = data[885] - ti;
        data[887] = tr - data[884];
        data[884] += tr;
        data[885] += ti;
        tr = data[884];
        ti = data[885];
        data[884] = data[880] - tr;
        data[885] = data[881] - ti;
        data[880] += tr;
        data[881] += ti;
        tr = data[886];
        ti = data[887];
        data[886] = data[882] - tr;
        data[887] = data[883] - ti;
        data[882] += tr;
        data[883] += ti;
    }
    // N = 4, at 888
    {
        uniform float tr = data[890];
        uniform float ti = data[891];
        data[890] = data[888] - tr;
        data[891] = data[889] - ti;
        data[888] += tr;
        data[889] += ti;
        tr = data[894];
        ti = data[895];
        data[894] = data[893] - ti;
        data[895] = tr - data[892];
        data[892] += tr;
        data[893] += ti;
        tr = data[892];
        ti = data[893];
        data[892] = data[888] - tr;
        data[893] = data[889] - ti;
        data[888] += tr;
        data[889] += ti;
        tr = data[894];
        ti = data[895];
        data[894] = data[890] - tr;
        data[895] = data[891] - ti;
        data[890] += tr;
        data[891] += ti;
    }
    // N = 8, at 880
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 888 ] * wr - data[ i + 889 ] * wi;
            uniform float tempi  = data[ i + 888 ] * wi + data[ i + 889 ] * wr;
            uniform float tempr2 = data[ i + 890 ] * wr2 - data[ i + 891 ] * wi2;
            uniform float tempi2 = data[ i + 890 ] * wi2 + data[ i + 891 ] * wr2;
            data[ i + 888 ] = data[ 880 + i ] - tempr;
            data[ i + 889 ] = data[ 881 + i ] - tempi;
            data[ i + 890 ] = data[ 882 + i ] - tempr2;
            data[ i + 891 ] = data[ 883 + i ] - tempi2;
            data[ 880 + i ] += tempr;
            data[ 881 + i ] += tempi;
            data[ 882 + i ] += tempr2;
            data[ 883 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 864
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 880 ] * wr - data[ i + 881 ] * wi;
            uniform float tempi  = data[ i + 880 ] * wi + data[ i + 881 ] * wr;
            uniform float tempr2 = data[ i + 882 ] * wr2 - data[ i + 883 ] * wi2;
            uniform float tempi2 = data[ i + 882 ] * wi2 + data[ i + 883 ] * wr2;
            data[ i + 880 ] = data[ 864 + i ] - tempr;
            data[ i + 881 ] = data[ 865 + i ] - tempi;
            data[ i + 882 ] = data[ 866 + i ] - tempr2;
            data[ i + 883 ] = data[ 867 + i ] - tempi2;
            data[ 864 + i ] += tempr;
            data[ 865 + i ] += tempi;
            data[ 866 + i ] += tempr2;
            data[ 867 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 832
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 864 ] * wr - data[ i + 865 ] * wi;
            uniform float tempi  = data[ i + 864 ] * wi + data[ i + 865 ] * wr;
            uniform float tempr2 = data[ i + 866 ] * wr2 - data[ i + 867 ] * wi2;
            uniform float tempi2 = data[ i + 866 ] * wi2 + data[ i + 867 ] * wr2;
            data[ i + 864 ] = data[ 832 + i ] - tempr;
            data[ i + 865 ] = data[ 833 + i ] - tempi;
            data[ i + 866 ] = data[ 834 + i ] - tempr2;
            data[ i + 867 ] = data[ 835 + i ] - tempi2;
            data[ 832 + i ] += tempr;
            data[ 833 + i ] += tempi;
            data[ 834 + i ] += tempr2;
            data[ 835 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 768
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 832 ] * wr - data[ i + 833 ] * wi;
            uniform float tempi  = data[ i + 832 ] * wi + data[ i + 833 ] * wr;
            uniform float tempr2 = data[ i + 834 ] * wr2 - data[ i + 835 ] * wi2;
            uniform float tempi2 = data[ i + 834 ] * wi2 + data[ i + 835 ] * wr2;
            data[ i + 832 ] = data[ 768 + i ] - tempr;
            data[ i + 833 ] = data[ 769 + i ] - tempi;
            data[ i + 834 ] = data[ 770 + i ] - tempr2;
            data[ i + 835 ] = data[ 771 + i ] - tempi2;
            data[ 768 + i ] += tempr;
            data[ 769 + i ] += tempi;
            data[ 770 + i ] += tempr2;
            data[ 771 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 896
    {
        uniform float tr = data[898];
        uniform float ti = data[899];
        data[898] = data[896] - tr;
        data[899] = data[897] - ti;
        data[896] += tr;
        data[897] += ti;
        tr = data[902];
        ti = data[903];
        data[902] = data[901] - ti;
        data[903] = tr - data[900];
        data[900] += tr;
        data[901] += ti;
        tr = data[900];
        ti = data[901];
        data[900] = data[896] - tr;
        data[901] = data[897] - ti;
        data[896] += tr;
        data[897] += ti;
        tr = data[902];
        ti = data[903];
        data[902] = data[898] - tr;
        data[903] = data[899] - ti;
        data[898] += tr;
        data[899] += ti;
    }
    // N = 4, at 904
    {
        uniform float tr = data[906];
        uniform float ti = data[907];
        data[906] = data[904] - tr;
        data[907] = data[905] - ti;
        data[904] += tr;
        data[905] += ti;
        tr = data[910];
        ti = data[911];
        data[910] = data[909] - ti;
        data[911] = tr - data[908];
        data[908] += tr;
        data[909] += ti;
        tr = data[908];
        ti = data[909];
        data[908] = data[904] - tr;
        data[909] = data[905] - ti;
        data[904] += tr;
        data[905] += ti;
        tr = data[910];
        ti = data[911];
        data[910] = data[906] - tr;
        data[911] = data[907] - ti;
        data[906] += tr;
        data[907] += ti;
    }
    // N = 8, at 896
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 904 ] * wr - data[ i + 905 ] * wi;
            uniform float tempi  = data[ i + 904 ] * wi + data[ i + 905 ] * wr;
            uniform float tempr2 = data[ i + 906 ] * wr2 - data[ i + 907 ] * wi2;
            uniform float tempi2 = data[ i + 906 ] * wi2 + data[ i + 907 ] * wr2;
            data[ i + 904 ] = data[ 896 + i ] - tempr;
            data[ i + 905 ] = data[ 897 + i ] - tempi;
            data[ i + 906 ] = data[ 898 + i ] - tempr2;
            data[ i + 907 ] = data[ 899 + i ] - tempi2;
            data[ 896 + i ] += tempr;
            data[ 897 + i ] += tempi;
            data[ 898 + i ] += tempr2;
            data[ 899 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 912
    {
        uniform float tr = data[914];
        uniform float ti = data[915];
        data[914] = data[912] - tr;
        data[915] = data[913] - ti;
        data[912] += tr;
        data[913] += ti;
        tr = data[918];
        ti = data[919];
        data[918] = data[917] - ti;
        data[919] = tr - data[916];
        data[916] += tr;
        data[917] += ti;
        tr = data[916];
        ti = data[917];
        data[916] = data[912] - tr;
        data[917] = data[913] - ti;
        data[912] += tr;
        data[913] += ti;
        tr = data[918];
        ti = data[919];
        data[918] = data[914] - tr;
        data[919] = data[915] - ti;
        data[914] += tr;
        data[915] += ti;
    }
    // N = 4, at 920
    {
        uniform float tr = data[922];
        uniform float ti = data[923];
        data[922] = data[920] - tr;
        data[923] = data[921] - ti;
        data[920] += tr;
        data[921] += ti;
        tr = data[926];
        ti = data[927];
        data[926] = data[925] - ti;
        data[927] = tr - data[924];
        data[924] += tr;
        data[925] += ti;
        tr = data[924];
        ti = data[925];
        data[924] = data[920] - tr;
        data[925] = data[921] - ti;
        data[920] += tr;
        data[921] += ti;
        tr = data[926];
        ti = data[927];
        data[926] = data[922] - tr;
        data[927] = data[923] - ti;
        data[922] += tr;
        data[923] += ti;
    }
    // N = 8, at 912
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 920 ] * wr - data[ i + 921 ] * wi;
            uniform float tempi  = data[ i + 920 ] * wi + data[ i + 921 ] * wr;
            uniform float tempr2 = data[ i + 922 ] * wr2 - data[ i + 923 ] * wi2;
            uniform float tempi2 = data[ i + 922 ] * wi2 + data[ i + 923 ] * wr2;
            data[ i + 920 ] = data[ 912 + i ] - tempr;
            data[ i + 921 ] = data[ 913 + i ] - tempi;
            data[ i + 922 ] = data[ 914 + i ] - tempr2;
            data[ i + 923 ] = data[ 915 + i ] - tempi2;
            data[ 912 + i ] += tempr;
            data[ 913 + i ] += tempi;
            data[ 914 + i ] += tempr2;
            data[ 915 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 896
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 912 ] * wr - data[ i + 913 ] * wi;
            uniform float tempi  = data[ i + 912 ] * wi + data[ i + 913 ] * wr;
            uniform float tempr2 = data[ i + 914 ] * wr2 - data[ i + 915 ] * wi2;
            uniform float tempi2 = data[ i + 914 ] * wi2 + data[ i + 915 ] * wr2;
            data[ i + 912 ] = data[ 896 + i ] - tempr;
            data[ i + 913 ] = data[ 897 + i ] - tempi;
            data[ i + 914 ] = data[ 898 + i ] - tempr2;
            data[ i + 915 ] = data[ 899 + i ] - tempi2;
            data[ 896 + i ] += tempr;
            data[ 897 + i ] += tempi;
            data[ 898 + i ] += tempr2;
            data[ 899 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 928
    {
        uniform float tr = data[930];
        uniform float ti = data[931];
        data[930] = data[928] - tr;
        data[931] = data[929] - ti;
        data[928] += tr;
        data[929] += ti;
        tr = data[934];
        ti = data[935];
        data[934] = data[933] - ti;
        data[935] = tr - data[932];
        data[932] += tr;
        data[933] += ti;
        tr = data[932];
        ti = data[933];
        data[932] = data[928] - tr;
        data[933] = data[929] - ti;
        data[928] += tr;
        data[929] += ti;
        tr = data[934];
        ti = data[935];
        data[934] = data[930] - tr;
        data[935] = data[931] - ti;
        data[930] += tr;
        data[931] += ti;
    }
    // N = 4, at 936
    {
        uniform float tr = data[938];
        uniform float ti = data[939];
        data[938] = data[936] - tr;
        data[939] = data[937] - ti;
        data[936] += tr;
        data[937] += ti;
        tr = data[942];
        ti = data[943];
        data[942] = data[941] - ti;
        data[943] = tr - data[940];
        data[940] += tr;
        data[941] += ti;
        tr = data[940];
        ti = data[941];
        data[940] = data[936] - tr;
        data[941] = data[937] - ti;
        data[936] += tr;
        data[937] += ti;
        tr = data[942];
        ti = data[943];
        data[942] = data[938] - tr;
        data[943] = data[939] - ti;
        data[938] += tr;
        data[939] += ti;
    }
    // N = 8, at 928
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 936 ] * wr - data[ i + 937 ] * wi;
            uniform float tempi  = data[ i + 936 ] * wi + data[ i + 937 ] * wr;
            uniform float tempr2 = data[ i + 938 ] * wr2 - data[ i + 939 ] * wi2;
            uniform float tempi2 = data[ i + 938 ] * wi2 + data[ i + 939 ] * wr2;
            data[ i + 936 ] = data[ 928 + i ] - tempr;
            data[ i + 937 ] = data[ 929 + i ] - tempi;
            data[ i + 938 ] = data[ 930 + i ] - tempr2;
            data[ i + 939 ] = data[ 931 + i ] - tempi2;
            data[ 928 + i ] += tempr;
            data[ 929 + i ] += tempi;
            data[ 930 + i ] += tempr2;
            data[ 931 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 944
    {
        uniform float tr = data[946];
        uniform float ti = data[947];
        data[946] = data[944] - tr;
        data[947] = data[945] - ti;
        data[944] += tr;
        data[945] += ti;
        tr = data[950];
        ti = data[951];
        data[950] = data[949] - ti;
        data[951] = tr - data[948];
        data[948] += tr;
        data[949] += ti;
        tr = data[948];
        ti = data[949];
        data[948] = data[944] - tr;
        data[949] = data[945] - ti;
        data[944] += tr;
        data[945] += ti;
        tr = data[950];
        ti = data[951];
        data[950] = data[946] - tr;
        data[951] = data[947] - ti;
        data[946] += tr;
        data[947] += ti;
    }
    // N = 4, at 952
    {
        uniform float tr = data[954];
        uniform float ti = data[955];
        data[954] = data[952] - tr;
        data[955] = data[953] - ti;
        data[952] += tr;
        data[953] += ti;
        tr = data[958];
        ti = data[959];
        data[958] = data[957] - ti;
        data[959] = tr - data[956];
        data[956] += tr;
        data[957] += ti;
        tr = data[956];
        ti = data[957];
        data[956] = data[952] - tr;
        data[957] = data[953] - ti;
        data[952] += tr;
        data[953] += ti;
        tr = data[958];
        ti = data[959];
        data[958] = data[954] - tr;
        data[959] = data[955] - ti;
        data[954] += tr;
        data[955] += ti;
    }
    // N = 8, at 944
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 952 ] * wr - data[ i + 953 ] * wi;
            uniform float tempi  = data[ i + 952 ] * wi + data[ i + 953 ] * wr;
            uniform float tempr2 = data[ i + 954 ] * wr2 - data[ i + 955 ] * wi2;
            uniform float tempi2 = data[ i + 954 ] * wi2 + data[ i + 955 ] * wr2;
            data[ i + 952 ] = data[ 944 + i ] - tempr;
            data[ i + 953 ] = data[ 945 + i ] - tempi;
            data[ i + 954 ] = data[ 946 + i ] - tempr2;
            data[ i + 955 ] = data[ 947 + i ] - tempi2;
            data[ 944 + i ] += tempr;
            data[ 945 + i ] += tempi;
            data[ 946 + i ] += tempr2;
            data[ 947 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 928
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 944 ] * wr - data[ i + 945 ] * wi;
            uniform float tempi  = data[ i + 944 ] * wi + data[ i + 945 ] * wr;
            uniform float tempr2 = data[ i + 946 ] * wr2 - data[ i + 947 ] * wi2;
            uniform float tempi2 = data[ i + 946 ] * wi2 + data[ i + 947 ] * wr2;
            data[ i + 944 ] = data[ 928 + i ] - tempr;
            data[ i + 945 ] = data[ 929 + i ] - tempi;
            data[ i + 946 ] = data[ 930 + i ] - tempr2;
            data[ i + 947 ] = data[ 931 + i ] - tempi2;
            data[ 928 + i ] += tempr;
            data[ 929 + i ] += tempi;
            data[ 930 + i ] += tempr2;
            data[ 931 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 896
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 928 ] * wr - data[ i + 929 ] * wi;
            uniform float tempi  = data[ i + 928 ] * wi + data[ i + 929 ] * wr;
            uniform float tempr2 = data[ i + 930 ] * wr2 - data[ i + 931 ] * wi2;
            uniform float tempi2 = data[ i + 930 ] * wi2 + data[ i + 931 ] * wr2;
            data[ i + 928 ] = data[ 896 + i ] - tempr;
            data[ i + 929 ] = data[ 897 + i ] - tempi;
            data[ i + 930 ] = data[ 898 + i ] - tempr2;
            data[ i + 931 ] = data[ 899 + i ] - tempi2;
            data[ 896 + i ] += tempr;
            data[ 897 + i ] += tempi;
            data[ 898 + i ] += tempr2;
            data[ 899 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 960
    {
        uniform float tr = data[962];
        uniform float ti = data[963];
        data[962] = data[960] - tr;
        data[963] = data[961] - ti;
        data[960] += tr;
        data[961] += ti;
        tr = data[966];
        ti = data[967];
        data[966] = data[965] - ti;
        data[967] = tr - data[964];
        data[964] += tr;
        data[965] += ti;
        tr = data[964];
        ti = data[965];
        data[964] = data[960] - tr;
        data[965] = data[961] - ti;
        data[960] += tr;
        data[961] += ti;
        tr = data[966];
        ti = data[967];
        data[966] = data[962] - tr;
        data[967] = data[963] - ti;
        data[962] += tr;
        data[963] += ti;
    }
    // N = 4, at 968
    {
        uniform float tr = data[970];
        uniform float ti = data[971];
        data[970] = data[968] - tr;
        data[971] = data[969] - ti;
        data[968] += tr;
        data[969] += ti;
        tr = data[974];
        ti = data[975];
        data[974] = data[973] - ti;
        data[975] = tr - data[972];
        data[972] += tr;
        data[973] += ti;
        tr = data[972];
        ti = data[973];
        data[972] = data[968] - tr;
        data[973] = data[969] - ti;
        data[968] += tr;
        data[969] += ti;
        tr = data[974];
        ti = data[975];
        data[974] = data[970] - tr;
        data[975] = data[971] - ti;
        data[970] += tr;
        data[971] += ti;
    }
    // N = 8, at 960
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 968 ] * wr - data[ i + 969 ] * wi;
            uniform float tempi  = data[ i + 968 ] * wi + data[ i + 969 ] * wr;
            uniform float tempr2 = data[ i + 970 ] * wr2 - data[ i + 971 ] * wi2;
            uniform float tempi2 = data[ i + 970 ] * wi2 + data[ i + 971 ] * wr2;
            data[ i + 968 ] = data[ 960 + i ] - tempr;
            data[ i + 969 ] = data[ 961 + i ] - tempi;
            data[ i + 970 ] = data[ 962 + i ] - tempr2;
            data[ i + 971 ] = data[ 963 + i ] - tempi2;
            data[ 960 + i ] += tempr;
            data[ 961 + i ] += tempi;
            data[ 962 + i ] += tempr2;
            data[ 963 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 976
    {
        uniform float tr = data[978];
        uniform float ti = data[979];
        data[978] = data[976] - tr;
        data[979] = data[977] - ti;
        data[976] += tr;
        data[977] += ti;
        tr = data[982];
        ti = data[983];
        data[982] = data[981] - ti;
        data[983] = tr - data[980];
        data[980] += tr;
        data[981] += ti;
        tr = data[980];
        ti = data[981];
        data[980] = data[976] - tr;
        data[981] = data[977] - ti;
        data[976] += tr;
        data[977] += ti;
        tr = data[982];
        ti = data[983];
        data[982] = data[978] - tr;
        data[983] = data[979] - ti;
        data[978] += tr;
        data[979] += ti;
    }
    // N = 4, at 984
    {
        uniform float tr = data[986];
        uniform float ti = data[987];
        data[986] = data[984] - tr;
        data[987] = data[985] - ti;
        data[984] += tr;
        data[985] += ti;
        tr = data[990];
        ti = data[991];
        data[990] = data[989] - ti;
        data[991] = tr - data[988];
        data[988] += tr;
        data[989] += ti;
        tr = data[988];
        ti = data[989];
        data[988] = data[984] - tr;
        data[989] = data[985] - ti;
        data[984] += tr;
        data[985] += ti;
        tr = data[990];
        ti = data[991];
        data[990] = data[986] - tr;
        data[991] = data[987] - ti;
        data[986] += tr;
        data[987] += ti;
    }
    // N = 8, at 976
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 984 ] * wr - data[ i + 985 ] * wi;
            uniform float tempi  = data[ i + 984 ] * wi + data[ i + 985 ] * wr;
            uniform float tempr2 = data[ i + 986 ] * wr2 - data[ i + 987 ] * wi2;
            uniform float tempi2 = data[ i + 986 ] * wi2 + data[ i + 987 ] * wr2;
            data[ i + 984 ] = data[ 976 + i ] - tempr;
            data[ i + 985 ] = data[ 977 + i ] - tempi;
            data[ i + 986 ] = data[ 978 + i ] - tempr2;
            data[ i + 987 ] = data[ 979 + i ] - tempi2;
            data[ 976 + i ] += tempr;
            data[ 977 + i ] += tempi;
            data[ 978 + i ] += tempr2;
            data[ 979 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 960
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 976 ] * wr - data[ i + 977 ] * wi;
            uniform float tempi  = data[ i + 976 ] * wi + data[ i + 977 ] * wr;
            uniform float tempr2 = data[ i + 978 ] * wr2 - data[ i + 979 ] * wi2;
            uniform float tempi2 = data[ i + 978 ] * wi2 + data[ i + 979 ] * wr2;
            data[ i + 976 ] = data[ 960 + i ] - tempr;
            data[ i + 977 ] = data[ 961 + i ] - tempi;
            data[ i + 978 ] = data[ 962 + i ] - tempr2;
            data[ i + 979 ] = data[ 963 + i ] - tempi2;
            data[ 960 + i ] += tempr;
            data[ 961 + i ] += tempi;
            data[ 962 + i ] += tempr2;
            data[ 963 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 992
    {
        uniform float tr = data[994];
        uniform float ti = data[995];
        data[994] = data[992] - tr;
        data[995] = data[993] - ti;
        data[992] += tr;
        data[993] += ti;
        tr = data[998];
        ti = data[999];
        data[998] = data[997] - ti;
        data[999] = tr - data[996];
        data[996] += tr;
        data[997] += ti;
        tr = data[996];
        ti = data[997];
        data[996] = data[992] - tr;
        data[997] = data[993] - ti;
        data[992] += tr;
        data[993] += ti;
        tr = data[998];
        ti = data[999];
        data[998] = data[994] - tr;
        data[999] = data[995] - ti;
        data[994] += tr;
        data[995] += ti;
    }
    // N = 4, at 1000
    {
        uniform float tr = data[1002];
        uniform float ti = data[1003];
        data[1002] = data[1000] - tr;
        data[1003] = data[1001] - ti;
        data[1000] += tr;
        data[1001] += ti;
        tr = data[1006];
        ti = data[1007];
        data[1006] = data[1005] - ti;
        data[1007] = tr - data[1004];
        data[1004] += tr;
        data[1005] += ti;
        tr = data[1004];
        ti = data[1005];
        data[1004] = data[1000] - tr;
        data[1005] = data[1001] - ti;
        data[1000] += tr;
        data[1001] += ti;
        tr = data[1006];
        ti = data[1007];
        data[1006] = data[1002] - tr;
        data[1007] = data[1003] - ti;
        data[1002] += tr;
        data[1003] += ti;
    }
    // N = 8, at 992
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1000 ] * wr - data[ i + 1001 ] * wi;
            uniform float tempi  = data[ i + 1000 ] * wi + data[ i + 1001 ] * wr;
            uniform float tempr2 = data[ i + 1002 ] * wr2 - data[ i + 1003 ] * wi2;
            uniform float tempi2 = data[ i + 1002 ] * wi2 + data[ i + 1003 ] * wr2;
            data[ i + 1000 ] = data[ 992 + i ] - tempr;
            data[ i + 1001 ] = data[ 993 + i ] - tempi;
            data[ i + 1002 ] = data[ 994 + i ] - tempr2;
            data[ i + 1003 ] = data[ 995 + i ] - tempi2;
            data[ 992 + i ] += tempr;
            data[ 993 + i ] += tempi;
            data[ 994 + i ] += tempr2;
            data[ 995 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1008
    {
        uniform float tr = data[1010];
        uniform float ti = data[1011];
        data[1010] = data[1008] - tr;
        data[1011] = data[1009] - ti;
        data[1008] += tr;
        data[1009] += ti;
        tr = data[1014];
        ti = data[1015];
        data[1014] = data[1013] - ti;
        data[1015] = tr - data[1012];
        data[1012] += tr;
        data[1013] += ti;
        tr = data[1012];
        ti = data[1013];
        data[1012] = data[1008] - tr;
        data[1013] = data[1009] - ti;
        data[1008] += tr;
        data[1009] += ti;
        tr = data[1014];
        ti = data[1015];
        data[1014] = data[1010] - tr;
        data[1015] = data[1011] - ti;
        data[1010] += tr;
        data[1011] += ti;
    }
    // N = 4, at 1016
    {
        uniform float tr = data[1018];
        uniform float ti = data[1019];
        data[1018] = data[1016] - tr;
        data[1019] = data[1017] - ti;
        data[1016] += tr;
        data[1017] += ti;
        tr = data[1022];
        ti = data[1023];
        data[1022] = data[1021] - ti;
        data[1023] = tr - data[1020];
        data[1020] += tr;
        data[1021] += ti;
        tr = data[1020];
        ti = data[1021];
        data[1020] = data[1016] - tr;
        data[1021] = data[1017] - ti;
        data[1016] += tr;
        data[1017] += ti;
        tr = data[1022];
        ti = data[1023];
        data[1022] = data[1018] - tr;
        data[1023] = data[1019] - ti;
        data[1018] += tr;
        data[1019] += ti;
    }
    // N = 8, at 1008
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1016 ] * wr - data[ i + 1017 ] * wi;
            uniform float tempi  = data[ i + 1016 ] * wi + data[ i + 1017 ] * wr;
            uniform float tempr2 = data[ i + 1018 ] * wr2 - data[ i + 1019 ] * wi2;
            uniform float tempi2 = data[ i + 1018 ] * wi2 + data[ i + 1019 ] * wr2;
            data[ i + 1016 ] = data[ 1008 + i ] - tempr;
            data[ i + 1017 ] = data[ 1009 + i ] - tempi;
            data[ i + 1018 ] = data[ 1010 + i ] - tempr2;
            data[ i + 1019 ] = data[ 1011 + i ] - tempi2;
            data[ 1008 + i ] += tempr;
            data[ 1009 + i ] += tempi;
            data[ 1010 + i ] += tempr2;
            data[ 1011 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 992
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1008 ] * wr - data[ i + 1009 ] * wi;
            uniform float tempi  = data[ i + 1008 ] * wi + data[ i + 1009 ] * wr;
            uniform float tempr2 = data[ i + 1010 ] * wr2 - data[ i + 1011 ] * wi2;
            uniform float tempi2 = data[ i + 1010 ] * wi2 + data[ i + 1011 ] * wr2;
            data[ i + 1008 ] = data[ 992 + i ] - tempr;
            data[ i + 1009 ] = data[ 993 + i ] - tempi;
            data[ i + 1010 ] = data[ 994 + i ] - tempr2;
            data[ i + 1011 ] = data[ 995 + i ] - tempi2;
            data[ 992 + i ] += tempr;
            data[ 993 + i ] += tempi;
            data[ 994 + i ] += tempr2;
            data[ 995 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 960
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 992 ] * wr - data[ i + 993 ] * wi;
            uniform float tempi  = data[ i + 992 ] * wi + data[ i + 993 ] * wr;
            uniform float tempr2 = data[ i + 994 ] * wr2 - data[ i + 995 ] * wi2;
            uniform float tempi2 = data[ i + 994 ] * wi2 + data[ i + 995 ] * wr2;
            data[ i + 992 ] = data[ 960 + i ] - tempr;
            data[ i + 993 ] = data[ 961 + i ] - tempi;
            data[ i + 994 ] = data[ 962 + i ] - tempr2;
            data[ i + 995 ] = data[ 963 + i ] - tempi2;
            data[ 960 + i ] += tempr;
            data[ 961 + i ] += tempi;
            data[ 962 + i ] += tempr2;
            data[ 963 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 896
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 960 ] * wr - data[ i + 961 ] * wi;
            uniform float tempi  = data[ i + 960 ] * wi + data[ i + 961 ] * wr;
            uniform float tempr2 = data[ i + 962 ] * wr2 - data[ i + 963 ] * wi2;
            uniform float tempi2 = data[ i + 962 ] * wi2 + data[ i + 963 ] * wr2;
            data[ i + 960 ] = data[ 896 + i ] - tempr;
            data[ i + 961 ] = data[ 897 + i ] - tempi;
            data[ i + 962 ] = data[ 898 + i ] - tempr2;
            data[ i + 963 ] = data[ 899 + i ] - tempi2;
            data[ 896 + i ] += tempr;
            data[ 897 + i ] += tempi;
            data[ 898 + i ] += tempr2;
            data[ 899 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 768
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 896 ] * wr - data[ i + 897 ] * wi;
            uniform float tempi  = data[ i + 896 ] * wi + data[ i + 897 ] * wr;
            uniform float tempr2 = data[ i + 898 ] * wr2 - data[ i + 899 ] * wi2;
            uniform float tempi2 = data[ i + 898 ] * wi2 + data[ i + 899 ] * wr2;
            data[ i + 896 ] = data[ 768 + i ] - tempr;
            data[ i + 897 ] = data[ 769 + i ] - tempi;
            data[ i + 898 ] = data[ 770 + i ] - tempr2;
            data[ i + 899 ] = data[ 771 + i ] - tempi2;
            data[ 768 + i ] += tempr;
            data[ 769 + i ] += tempi;
            data[ 770 + i ] += tempr2;
            data[ 771 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 256, at 512
    {
        uniform const_expr float sina = -0.012271538627185888531423f;
        uniform const_expr float sinb = -0.024541229205668591006884f;

        uniform const_expr float wpr = -0.000301181320557030655742f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 256; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 768 ] * wr - data[ i + 769 ] * wi;
            uniform float tempi  = data[ i + 768 ] * wi + data[ i + 769 ] * wr;
            uniform float tempr2 = data[ i + 770 ] * wr2 - data[ i + 771 ] * wi2;
            uniform float tempi2 = data[ i + 770 ] * wi2 + data[ i + 771 ] * wr2;
            data[ i + 768 ] = data[ 512 + i ] - tempr;
            data[ i + 769 ] = data[ 513 + i ] - tempi;
            data[ i + 770 ] = data[ 514 + i ] - tempr2;
            data[ i + 771 ] = data[ 515 + i ] - tempi2;
            data[ 512 + i ] += tempr;
            data[ 513 + i ] += tempi;
            data[ 514 + i ] += tempr2;
            data[ 515 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 512, at 0
    {
        uniform const_expr float sina = -0.006135884819898434171248f;
        uniform const_expr float sinb = -0.012271538627185888531423f;

        uniform const_expr float wpr = -0.000075298165046120077719f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 512; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 512 ] * wr - data[ i + 513 ] * wi;
            uniform float tempi  = data[ i + 512 ] * wi + data[ i + 513 ] * wr;
            uniform float tempr2 = data[ i + 514 ] * wr2 - data[ i + 515 ] * wi2;
            uniform float tempi2 = data[ i + 514 ] * wi2 + data[ i + 515 ] * wr2;
            data[ i + 512 ] = data[ 0 + i ] - tempr;
            data[ i + 513 ] = data[ 1 + i ] - tempi;
            data[ i + 514 ] = data[ 2 + i ] - tempr2;
            data[ i + 515 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1024
    {
        uniform float tr = data[1026];
        uniform float ti = data[1027];
        data[1026] = data[1024] - tr;
        data[1027] = data[1025] - ti;
        data[1024] += tr;
        data[1025] += ti;
        tr = data[1030];
        ti = data[1031];
        data[1030] = data[1029] - ti;
        data[1031] = tr - data[1028];
        data[1028] += tr;
        data[1029] += ti;
        tr = data[1028];
        ti = data[1029];
        data[1028] = data[1024] - tr;
        data[1029] = data[1025] - ti;
        data[1024] += tr;
        data[1025] += ti;
        tr = data[1030];
        ti = data[1031];
        data[1030] = data[1026] - tr;
        data[1031] = data[1027] - ti;
        data[1026] += tr;
        data[1027] += ti;
    }
    // N = 4, at 1032
    {
        uniform float tr = data[1034];
        uniform float ti = data[1035];
        data[1034] = data[1032] - tr;
        data[1035] = data[1033] - ti;
        data[1032] += tr;
        data[1033] += ti;
        tr = data[1038];
        ti = data[1039];
        data[1038] = data[1037] - ti;
        data[1039] = tr - data[1036];
        data[1036] += tr;
        data[1037] += ti;
        tr = data[1036];
        ti = data[1037];
        data[1036] = data[1032] - tr;
        data[1037] = data[1033] - ti;
        data[1032] += tr;
        data[1033] += ti;
        tr = data[1038];
        ti = data[1039];
        data[1038] = data[1034] - tr;
        data[1039] = data[1035] - ti;
        data[1034] += tr;
        data[1035] += ti;
    }
    // N = 8, at 1024
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1032 ] * wr - data[ i + 1033 ] * wi;
            uniform float tempi  = data[ i + 1032 ] * wi + data[ i + 1033 ] * wr;
            uniform float tempr2 = data[ i + 1034 ] * wr2 - data[ i + 1035 ] * wi2;
            uniform float tempi2 = data[ i + 1034 ] * wi2 + data[ i + 1035 ] * wr2;
            data[ i + 1032 ] = data[ 1024 + i ] - tempr;
            data[ i + 1033 ] = data[ 1025 + i ] - tempi;
            data[ i + 1034 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1035 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1040
    {
        uniform float tr = data[1042];
        uniform float ti = data[1043];
        data[1042] = data[1040] - tr;
        data[1043] = data[1041] - ti;
        data[1040] += tr;
        data[1041] += ti;
        tr = data[1046];
        ti = data[1047];
        data[1046] = data[1045] - ti;
        data[1047] = tr - data[1044];
        data[1044] += tr;
        data[1045] += ti;
        tr = data[1044];
        ti = data[1045];
        data[1044] = data[1040] - tr;
        data[1045] = data[1041] - ti;
        data[1040] += tr;
        data[1041] += ti;
        tr = data[1046];
        ti = data[1047];
        data[1046] = data[1042] - tr;
        data[1047] = data[1043] - ti;
        data[1042] += tr;
        data[1043] += ti;
    }
    // N = 4, at 1048
    {
        uniform float tr = data[1050];
        uniform float ti = data[1051];
        data[1050] = data[1048] - tr;
        data[1051] = data[1049] - ti;
        data[1048] += tr;
        data[1049] += ti;
        tr = data[1054];
        ti = data[1055];
        data[1054] = data[1053] - ti;
        data[1055] = tr - data[1052];
        data[1052] += tr;
        data[1053] += ti;
        tr = data[1052];
        ti = data[1053];
        data[1052] = data[1048] - tr;
        data[1053] = data[1049] - ti;
        data[1048] += tr;
        data[1049] += ti;
        tr = data[1054];
        ti = data[1055];
        data[1054] = data[1050] - tr;
        data[1055] = data[1051] - ti;
        data[1050] += tr;
        data[1051] += ti;
    }
    // N = 8, at 1040
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1048 ] * wr - data[ i + 1049 ] * wi;
            uniform float tempi  = data[ i + 1048 ] * wi + data[ i + 1049 ] * wr;
            uniform float tempr2 = data[ i + 1050 ] * wr2 - data[ i + 1051 ] * wi2;
            uniform float tempi2 = data[ i + 1050 ] * wi2 + data[ i + 1051 ] * wr2;
            data[ i + 1048 ] = data[ 1040 + i ] - tempr;
            data[ i + 1049 ] = data[ 1041 + i ] - tempi;
            data[ i + 1050 ] = data[ 1042 + i ] - tempr2;
            data[ i + 1051 ] = data[ 1043 + i ] - tempi2;
            data[ 1040 + i ] += tempr;
            data[ 1041 + i ] += tempi;
            data[ 1042 + i ] += tempr2;
            data[ 1043 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1024
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1040 ] * wr - data[ i + 1041 ] * wi;
            uniform float tempi  = data[ i + 1040 ] * wi + data[ i + 1041 ] * wr;
            uniform float tempr2 = data[ i + 1042 ] * wr2 - data[ i + 1043 ] * wi2;
            uniform float tempi2 = data[ i + 1042 ] * wi2 + data[ i + 1043 ] * wr2;
            data[ i + 1040 ] = data[ 1024 + i ] - tempr;
            data[ i + 1041 ] = data[ 1025 + i ] - tempi;
            data[ i + 1042 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1043 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1056
    {
        uniform float tr = data[1058];
        uniform float ti = data[1059];
        data[1058] = data[1056] - tr;
        data[1059] = data[1057] - ti;
        data[1056] += tr;
        data[1057] += ti;
        tr = data[1062];
        ti = data[1063];
        data[1062] = data[1061] - ti;
        data[1063] = tr - data[1060];
        data[1060] += tr;
        data[1061] += ti;
        tr = data[1060];
        ti = data[1061];
        data[1060] = data[1056] - tr;
        data[1061] = data[1057] - ti;
        data[1056] += tr;
        data[1057] += ti;
        tr = data[1062];
        ti = data[1063];
        data[1062] = data[1058] - tr;
        data[1063] = data[1059] - ti;
        data[1058] += tr;
        data[1059] += ti;
    }
    // N = 4, at 1064
    {
        uniform float tr = data[1066];
        uniform float ti = data[1067];
        data[1066] = data[1064] - tr;
        data[1067] = data[1065] - ti;
        data[1064] += tr;
        data[1065] += ti;
        tr = data[1070];
        ti = data[1071];
        data[1070] = data[1069] - ti;
        data[1071] = tr - data[1068];
        data[1068] += tr;
        data[1069] += ti;
        tr = data[1068];
        ti = data[1069];
        data[1068] = data[1064] - tr;
        data[1069] = data[1065] - ti;
        data[1064] += tr;
        data[1065] += ti;
        tr = data[1070];
        ti = data[1071];
        data[1070] = data[1066] - tr;
        data[1071] = data[1067] - ti;
        data[1066] += tr;
        data[1067] += ti;
    }
    // N = 8, at 1056
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1064 ] * wr - data[ i + 1065 ] * wi;
            uniform float tempi  = data[ i + 1064 ] * wi + data[ i + 1065 ] * wr;
            uniform float tempr2 = data[ i + 1066 ] * wr2 - data[ i + 1067 ] * wi2;
            uniform float tempi2 = data[ i + 1066 ] * wi2 + data[ i + 1067 ] * wr2;
            data[ i + 1064 ] = data[ 1056 + i ] - tempr;
            data[ i + 1065 ] = data[ 1057 + i ] - tempi;
            data[ i + 1066 ] = data[ 1058 + i ] - tempr2;
            data[ i + 1067 ] = data[ 1059 + i ] - tempi2;
            data[ 1056 + i ] += tempr;
            data[ 1057 + i ] += tempi;
            data[ 1058 + i ] += tempr2;
            data[ 1059 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1072
    {
        uniform float tr = data[1074];
        uniform float ti = data[1075];
        data[1074] = data[1072] - tr;
        data[1075] = data[1073] - ti;
        data[1072] += tr;
        data[1073] += ti;
        tr = data[1078];
        ti = data[1079];
        data[1078] = data[1077] - ti;
        data[1079] = tr - data[1076];
        data[1076] += tr;
        data[1077] += ti;
        tr = data[1076];
        ti = data[1077];
        data[1076] = data[1072] - tr;
        data[1077] = data[1073] - ti;
        data[1072] += tr;
        data[1073] += ti;
        tr = data[1078];
        ti = data[1079];
        data[1078] = data[1074] - tr;
        data[1079] = data[1075] - ti;
        data[1074] += tr;
        data[1075] += ti;
    }
    // N = 4, at 1080
    {
        uniform float tr = data[1082];
        uniform float ti = data[1083];
        data[1082] = data[1080] - tr;
        data[1083] = data[1081] - ti;
        data[1080] += tr;
        data[1081] += ti;
        tr = data[1086];
        ti = data[1087];
        data[1086] = data[1085] - ti;
        data[1087] = tr - data[1084];
        data[1084] += tr;
        data[1085] += ti;
        tr = data[1084];
        ti = data[1085];
        data[1084] = data[1080] - tr;
        data[1085] = data[1081] - ti;
        data[1080] += tr;
        data[1081] += ti;
        tr = data[1086];
        ti = data[1087];
        data[1086] = data[1082] - tr;
        data[1087] = data[1083] - ti;
        data[1082] += tr;
        data[1083] += ti;
    }
    // N = 8, at 1072
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1080 ] * wr - data[ i + 1081 ] * wi;
            uniform float tempi  = data[ i + 1080 ] * wi + data[ i + 1081 ] * wr;
            uniform float tempr2 = data[ i + 1082 ] * wr2 - data[ i + 1083 ] * wi2;
            uniform float tempi2 = data[ i + 1082 ] * wi2 + data[ i + 1083 ] * wr2;
            data[ i + 1080 ] = data[ 1072 + i ] - tempr;
            data[ i + 1081 ] = data[ 1073 + i ] - tempi;
            data[ i + 1082 ] = data[ 1074 + i ] - tempr2;
            data[ i + 1083 ] = data[ 1075 + i ] - tempi2;
            data[ 1072 + i ] += tempr;
            data[ 1073 + i ] += tempi;
            data[ 1074 + i ] += tempr2;
            data[ 1075 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1056
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1072 ] * wr - data[ i + 1073 ] * wi;
            uniform float tempi  = data[ i + 1072 ] * wi + data[ i + 1073 ] * wr;
            uniform float tempr2 = data[ i + 1074 ] * wr2 - data[ i + 1075 ] * wi2;
            uniform float tempi2 = data[ i + 1074 ] * wi2 + data[ i + 1075 ] * wr2;
            data[ i + 1072 ] = data[ 1056 + i ] - tempr;
            data[ i + 1073 ] = data[ 1057 + i ] - tempi;
            data[ i + 1074 ] = data[ 1058 + i ] - tempr2;
            data[ i + 1075 ] = data[ 1059 + i ] - tempi2;
            data[ 1056 + i ] += tempr;
            data[ 1057 + i ] += tempi;
            data[ 1058 + i ] += tempr2;
            data[ 1059 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1024
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1056 ] * wr - data[ i + 1057 ] * wi;
            uniform float tempi  = data[ i + 1056 ] * wi + data[ i + 1057 ] * wr;
            uniform float tempr2 = data[ i + 1058 ] * wr2 - data[ i + 1059 ] * wi2;
            uniform float tempi2 = data[ i + 1058 ] * wi2 + data[ i + 1059 ] * wr2;
            data[ i + 1056 ] = data[ 1024 + i ] - tempr;
            data[ i + 1057 ] = data[ 1025 + i ] - tempi;
            data[ i + 1058 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1059 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1088
    {
        uniform float tr = data[1090];
        uniform float ti = data[1091];
        data[1090] = data[1088] - tr;
        data[1091] = data[1089] - ti;
        data[1088] += tr;
        data[1089] += ti;
        tr = data[1094];
        ti = data[1095];
        data[1094] = data[1093] - ti;
        data[1095] = tr - data[1092];
        data[1092] += tr;
        data[1093] += ti;
        tr = data[1092];
        ti = data[1093];
        data[1092] = data[1088] - tr;
        data[1093] = data[1089] - ti;
        data[1088] += tr;
        data[1089] += ti;
        tr = data[1094];
        ti = data[1095];
        data[1094] = data[1090] - tr;
        data[1095] = data[1091] - ti;
        data[1090] += tr;
        data[1091] += ti;
    }
    // N = 4, at 1096
    {
        uniform float tr = data[1098];
        uniform float ti = data[1099];
        data[1098] = data[1096] - tr;
        data[1099] = data[1097] - ti;
        data[1096] += tr;
        data[1097] += ti;
        tr = data[1102];
        ti = data[1103];
        data[1102] = data[1101] - ti;
        data[1103] = tr - data[1100];
        data[1100] += tr;
        data[1101] += ti;
        tr = data[1100];
        ti = data[1101];
        data[1100] = data[1096] - tr;
        data[1101] = data[1097] - ti;
        data[1096] += tr;
        data[1097] += ti;
        tr = data[1102];
        ti = data[1103];
        data[1102] = data[1098] - tr;
        data[1103] = data[1099] - ti;
        data[1098] += tr;
        data[1099] += ti;
    }
    // N = 8, at 1088
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1096 ] * wr - data[ i + 1097 ] * wi;
            uniform float tempi  = data[ i + 1096 ] * wi + data[ i + 1097 ] * wr;
            uniform float tempr2 = data[ i + 1098 ] * wr2 - data[ i + 1099 ] * wi2;
            uniform float tempi2 = data[ i + 1098 ] * wi2 + data[ i + 1099 ] * wr2;
            data[ i + 1096 ] = data[ 1088 + i ] - tempr;
            data[ i + 1097 ] = data[ 1089 + i ] - tempi;
            data[ i + 1098 ] = data[ 1090 + i ] - tempr2;
            data[ i + 1099 ] = data[ 1091 + i ] - tempi2;
            data[ 1088 + i ] += tempr;
            data[ 1089 + i ] += tempi;
            data[ 1090 + i ] += tempr2;
            data[ 1091 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1104
    {
        uniform float tr = data[1106];
        uniform float ti = data[1107];
        data[1106] = data[1104] - tr;
        data[1107] = data[1105] - ti;
        data[1104] += tr;
        data[1105] += ti;
        tr = data[1110];
        ti = data[1111];
        data[1110] = data[1109] - ti;
        data[1111] = tr - data[1108];
        data[1108] += tr;
        data[1109] += ti;
        tr = data[1108];
        ti = data[1109];
        data[1108] = data[1104] - tr;
        data[1109] = data[1105] - ti;
        data[1104] += tr;
        data[1105] += ti;
        tr = data[1110];
        ti = data[1111];
        data[1110] = data[1106] - tr;
        data[1111] = data[1107] - ti;
        data[1106] += tr;
        data[1107] += ti;
    }
    // N = 4, at 1112
    {
        uniform float tr = data[1114];
        uniform float ti = data[1115];
        data[1114] = data[1112] - tr;
        data[1115] = data[1113] - ti;
        data[1112] += tr;
        data[1113] += ti;
        tr = data[1118];
        ti = data[1119];
        data[1118] = data[1117] - ti;
        data[1119] = tr - data[1116];
        data[1116] += tr;
        data[1117] += ti;
        tr = data[1116];
        ti = data[1117];
        data[1116] = data[1112] - tr;
        data[1117] = data[1113] - ti;
        data[1112] += tr;
        data[1113] += ti;
        tr = data[1118];
        ti = data[1119];
        data[1118] = data[1114] - tr;
        data[1119] = data[1115] - ti;
        data[1114] += tr;
        data[1115] += ti;
    }
    // N = 8, at 1104
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1112 ] * wr - data[ i + 1113 ] * wi;
            uniform float tempi  = data[ i + 1112 ] * wi + data[ i + 1113 ] * wr;
            uniform float tempr2 = data[ i + 1114 ] * wr2 - data[ i + 1115 ] * wi2;
            uniform float tempi2 = data[ i + 1114 ] * wi2 + data[ i + 1115 ] * wr2;
            data[ i + 1112 ] = data[ 1104 + i ] - tempr;
            data[ i + 1113 ] = data[ 1105 + i ] - tempi;
            data[ i + 1114 ] = data[ 1106 + i ] - tempr2;
            data[ i + 1115 ] = data[ 1107 + i ] - tempi2;
            data[ 1104 + i ] += tempr;
            data[ 1105 + i ] += tempi;
            data[ 1106 + i ] += tempr2;
            data[ 1107 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1088
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1104 ] * wr - data[ i + 1105 ] * wi;
            uniform float tempi  = data[ i + 1104 ] * wi + data[ i + 1105 ] * wr;
            uniform float tempr2 = data[ i + 1106 ] * wr2 - data[ i + 1107 ] * wi2;
            uniform float tempi2 = data[ i + 1106 ] * wi2 + data[ i + 1107 ] * wr2;
            data[ i + 1104 ] = data[ 1088 + i ] - tempr;
            data[ i + 1105 ] = data[ 1089 + i ] - tempi;
            data[ i + 1106 ] = data[ 1090 + i ] - tempr2;
            data[ i + 1107 ] = data[ 1091 + i ] - tempi2;
            data[ 1088 + i ] += tempr;
            data[ 1089 + i ] += tempi;
            data[ 1090 + i ] += tempr2;
            data[ 1091 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1120
    {
        uniform float tr = data[1122];
        uniform float ti = data[1123];
        data[1122] = data[1120] - tr;
        data[1123] = data[1121] - ti;
        data[1120] += tr;
        data[1121] += ti;
        tr = data[1126];
        ti = data[1127];
        data[1126] = data[1125] - ti;
        data[1127] = tr - data[1124];
        data[1124] += tr;
        data[1125] += ti;
        tr = data[1124];
        ti = data[1125];
        data[1124] = data[1120] - tr;
        data[1125] = data[1121] - ti;
        data[1120] += tr;
        data[1121] += ti;
        tr = data[1126];
        ti = data[1127];
        data[1126] = data[1122] - tr;
        data[1127] = data[1123] - ti;
        data[1122] += tr;
        data[1123] += ti;
    }
    // N = 4, at 1128
    {
        uniform float tr = data[1130];
        uniform float ti = data[1131];
        data[1130] = data[1128] - tr;
        data[1131] = data[1129] - ti;
        data[1128] += tr;
        data[1129] += ti;
        tr = data[1134];
        ti = data[1135];
        data[1134] = data[1133] - ti;
        data[1135] = tr - data[1132];
        data[1132] += tr;
        data[1133] += ti;
        tr = data[1132];
        ti = data[1133];
        data[1132] = data[1128] - tr;
        data[1133] = data[1129] - ti;
        data[1128] += tr;
        data[1129] += ti;
        tr = data[1134];
        ti = data[1135];
        data[1134] = data[1130] - tr;
        data[1135] = data[1131] - ti;
        data[1130] += tr;
        data[1131] += ti;
    }
    // N = 8, at 1120
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1128 ] * wr - data[ i + 1129 ] * wi;
            uniform float tempi  = data[ i + 1128 ] * wi + data[ i + 1129 ] * wr;
            uniform float tempr2 = data[ i + 1130 ] * wr2 - data[ i + 1131 ] * wi2;
            uniform float tempi2 = data[ i + 1130 ] * wi2 + data[ i + 1131 ] * wr2;
            data[ i + 1128 ] = data[ 1120 + i ] - tempr;
            data[ i + 1129 ] = data[ 1121 + i ] - tempi;
            data[ i + 1130 ] = data[ 1122 + i ] - tempr2;
            data[ i + 1131 ] = data[ 1123 + i ] - tempi2;
            data[ 1120 + i ] += tempr;
            data[ 1121 + i ] += tempi;
            data[ 1122 + i ] += tempr2;
            data[ 1123 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1136
    {
        uniform float tr = data[1138];
        uniform float ti = data[1139];
        data[1138] = data[1136] - tr;
        data[1139] = data[1137] - ti;
        data[1136] += tr;
        data[1137] += ti;
        tr = data[1142];
        ti = data[1143];
        data[1142] = data[1141] - ti;
        data[1143] = tr - data[1140];
        data[1140] += tr;
        data[1141] += ti;
        tr = data[1140];
        ti = data[1141];
        data[1140] = data[1136] - tr;
        data[1141] = data[1137] - ti;
        data[1136] += tr;
        data[1137] += ti;
        tr = data[1142];
        ti = data[1143];
        data[1142] = data[1138] - tr;
        data[1143] = data[1139] - ti;
        data[1138] += tr;
        data[1139] += ti;
    }
    // N = 4, at 1144
    {
        uniform float tr = data[1146];
        uniform float ti = data[1147];
        data[1146] = data[1144] - tr;
        data[1147] = data[1145] - ti;
        data[1144] += tr;
        data[1145] += ti;
        tr = data[1150];
        ti = data[1151];
        data[1150] = data[1149] - ti;
        data[1151] = tr - data[1148];
        data[1148] += tr;
        data[1149] += ti;
        tr = data[1148];
        ti = data[1149];
        data[1148] = data[1144] - tr;
        data[1149] = data[1145] - ti;
        data[1144] += tr;
        data[1145] += ti;
        tr = data[1150];
        ti = data[1151];
        data[1150] = data[1146] - tr;
        data[1151] = data[1147] - ti;
        data[1146] += tr;
        data[1147] += ti;
    }
    // N = 8, at 1136
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1144 ] * wr - data[ i + 1145 ] * wi;
            uniform float tempi  = data[ i + 1144 ] * wi + data[ i + 1145 ] * wr;
            uniform float tempr2 = data[ i + 1146 ] * wr2 - data[ i + 1147 ] * wi2;
            uniform float tempi2 = data[ i + 1146 ] * wi2 + data[ i + 1147 ] * wr2;
            data[ i + 1144 ] = data[ 1136 + i ] - tempr;
            data[ i + 1145 ] = data[ 1137 + i ] - tempi;
            data[ i + 1146 ] = data[ 1138 + i ] - tempr2;
            data[ i + 1147 ] = data[ 1139 + i ] - tempi2;
            data[ 1136 + i ] += tempr;
            data[ 1137 + i ] += tempi;
            data[ 1138 + i ] += tempr2;
            data[ 1139 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1120
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1136 ] * wr - data[ i + 1137 ] * wi;
            uniform float tempi  = data[ i + 1136 ] * wi + data[ i + 1137 ] * wr;
            uniform float tempr2 = data[ i + 1138 ] * wr2 - data[ i + 1139 ] * wi2;
            uniform float tempi2 = data[ i + 1138 ] * wi2 + data[ i + 1139 ] * wr2;
            data[ i + 1136 ] = data[ 1120 + i ] - tempr;
            data[ i + 1137 ] = data[ 1121 + i ] - tempi;
            data[ i + 1138 ] = data[ 1122 + i ] - tempr2;
            data[ i + 1139 ] = data[ 1123 + i ] - tempi2;
            data[ 1120 + i ] += tempr;
            data[ 1121 + i ] += tempi;
            data[ 1122 + i ] += tempr2;
            data[ 1123 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1088
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1120 ] * wr - data[ i + 1121 ] * wi;
            uniform float tempi  = data[ i + 1120 ] * wi + data[ i + 1121 ] * wr;
            uniform float tempr2 = data[ i + 1122 ] * wr2 - data[ i + 1123 ] * wi2;
            uniform float tempi2 = data[ i + 1122 ] * wi2 + data[ i + 1123 ] * wr2;
            data[ i + 1120 ] = data[ 1088 + i ] - tempr;
            data[ i + 1121 ] = data[ 1089 + i ] - tempi;
            data[ i + 1122 ] = data[ 1090 + i ] - tempr2;
            data[ i + 1123 ] = data[ 1091 + i ] - tempi2;
            data[ 1088 + i ] += tempr;
            data[ 1089 + i ] += tempi;
            data[ 1090 + i ] += tempr2;
            data[ 1091 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1024
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1088 ] * wr - data[ i + 1089 ] * wi;
            uniform float tempi  = data[ i + 1088 ] * wi + data[ i + 1089 ] * wr;
            uniform float tempr2 = data[ i + 1090 ] * wr2 - data[ i + 1091 ] * wi2;
            uniform float tempi2 = data[ i + 1090 ] * wi2 + data[ i + 1091 ] * wr2;
            data[ i + 1088 ] = data[ 1024 + i ] - tempr;
            data[ i + 1089 ] = data[ 1025 + i ] - tempi;
            data[ i + 1090 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1091 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1152
    {
        uniform float tr = data[1154];
        uniform float ti = data[1155];
        data[1154] = data[1152] - tr;
        data[1155] = data[1153] - ti;
        data[1152] += tr;
        data[1153] += ti;
        tr = data[1158];
        ti = data[1159];
        data[1158] = data[1157] - ti;
        data[1159] = tr - data[1156];
        data[1156] += tr;
        data[1157] += ti;
        tr = data[1156];
        ti = data[1157];
        data[1156] = data[1152] - tr;
        data[1157] = data[1153] - ti;
        data[1152] += tr;
        data[1153] += ti;
        tr = data[1158];
        ti = data[1159];
        data[1158] = data[1154] - tr;
        data[1159] = data[1155] - ti;
        data[1154] += tr;
        data[1155] += ti;
    }
    // N = 4, at 1160
    {
        uniform float tr = data[1162];
        uniform float ti = data[1163];
        data[1162] = data[1160] - tr;
        data[1163] = data[1161] - ti;
        data[1160] += tr;
        data[1161] += ti;
        tr = data[1166];
        ti = data[1167];
        data[1166] = data[1165] - ti;
        data[1167] = tr - data[1164];
        data[1164] += tr;
        data[1165] += ti;
        tr = data[1164];
        ti = data[1165];
        data[1164] = data[1160] - tr;
        data[1165] = data[1161] - ti;
        data[1160] += tr;
        data[1161] += ti;
        tr = data[1166];
        ti = data[1167];
        data[1166] = data[1162] - tr;
        data[1167] = data[1163] - ti;
        data[1162] += tr;
        data[1163] += ti;
    }
    // N = 8, at 1152
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1160 ] * wr - data[ i + 1161 ] * wi;
            uniform float tempi  = data[ i + 1160 ] * wi + data[ i + 1161 ] * wr;
            uniform float tempr2 = data[ i + 1162 ] * wr2 - data[ i + 1163 ] * wi2;
            uniform float tempi2 = data[ i + 1162 ] * wi2 + data[ i + 1163 ] * wr2;
            data[ i + 1160 ] = data[ 1152 + i ] - tempr;
            data[ i + 1161 ] = data[ 1153 + i ] - tempi;
            data[ i + 1162 ] = data[ 1154 + i ] - tempr2;
            data[ i + 1163 ] = data[ 1155 + i ] - tempi2;
            data[ 1152 + i ] += tempr;
            data[ 1153 + i ] += tempi;
            data[ 1154 + i ] += tempr2;
            data[ 1155 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1168
    {
        uniform float tr = data[1170];
        uniform float ti = data[1171];
        data[1170] = data[1168] - tr;
        data[1171] = data[1169] - ti;
        data[1168] += tr;
        data[1169] += ti;
        tr = data[1174];
        ti = data[1175];
        data[1174] = data[1173] - ti;
        data[1175] = tr - data[1172];
        data[1172] += tr;
        data[1173] += ti;
        tr = data[1172];
        ti = data[1173];
        data[1172] = data[1168] - tr;
        data[1173] = data[1169] - ti;
        data[1168] += tr;
        data[1169] += ti;
        tr = data[1174];
        ti = data[1175];
        data[1174] = data[1170] - tr;
        data[1175] = data[1171] - ti;
        data[1170] += tr;
        data[1171] += ti;
    }
    // N = 4, at 1176
    {
        uniform float tr = data[1178];
        uniform float ti = data[1179];
        data[1178] = data[1176] - tr;
        data[1179] = data[1177] - ti;
        data[1176] += tr;
        data[1177] += ti;
        tr = data[1182];
        ti = data[1183];
        data[1182] = data[1181] - ti;
        data[1183] = tr - data[1180];
        data[1180] += tr;
        data[1181] += ti;
        tr = data[1180];
        ti = data[1181];
        data[1180] = data[1176] - tr;
        data[1181] = data[1177] - ti;
        data[1176] += tr;
        data[1177] += ti;
        tr = data[1182];
        ti = data[1183];
        data[1182] = data[1178] - tr;
        data[1183] = data[1179] - ti;
        data[1178] += tr;
        data[1179] += ti;
    }
    // N = 8, at 1168
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1176 ] * wr - data[ i + 1177 ] * wi;
            uniform float tempi  = data[ i + 1176 ] * wi + data[ i + 1177 ] * wr;
            uniform float tempr2 = data[ i + 1178 ] * wr2 - data[ i + 1179 ] * wi2;
            uniform float tempi2 = data[ i + 1178 ] * wi2 + data[ i + 1179 ] * wr2;
            data[ i + 1176 ] = data[ 1168 + i ] - tempr;
            data[ i + 1177 ] = data[ 1169 + i ] - tempi;
            data[ i + 1178 ] = data[ 1170 + i ] - tempr2;
            data[ i + 1179 ] = data[ 1171 + i ] - tempi2;
            data[ 1168 + i ] += tempr;
            data[ 1169 + i ] += tempi;
            data[ 1170 + i ] += tempr2;
            data[ 1171 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1152
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1168 ] * wr - data[ i + 1169 ] * wi;
            uniform float tempi  = data[ i + 1168 ] * wi + data[ i + 1169 ] * wr;
            uniform float tempr2 = data[ i + 1170 ] * wr2 - data[ i + 1171 ] * wi2;
            uniform float tempi2 = data[ i + 1170 ] * wi2 + data[ i + 1171 ] * wr2;
            data[ i + 1168 ] = data[ 1152 + i ] - tempr;
            data[ i + 1169 ] = data[ 1153 + i ] - tempi;
            data[ i + 1170 ] = data[ 1154 + i ] - tempr2;
            data[ i + 1171 ] = data[ 1155 + i ] - tempi2;
            data[ 1152 + i ] += tempr;
            data[ 1153 + i ] += tempi;
            data[ 1154 + i ] += tempr2;
            data[ 1155 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1184
    {
        uniform float tr = data[1186];
        uniform float ti = data[1187];
        data[1186] = data[1184] - tr;
        data[1187] = data[1185] - ti;
        data[1184] += tr;
        data[1185] += ti;
        tr = data[1190];
        ti = data[1191];
        data[1190] = data[1189] - ti;
        data[1191] = tr - data[1188];
        data[1188] += tr;
        data[1189] += ti;
        tr = data[1188];
        ti = data[1189];
        data[1188] = data[1184] - tr;
        data[1189] = data[1185] - ti;
        data[1184] += tr;
        data[1185] += ti;
        tr = data[1190];
        ti = data[1191];
        data[1190] = data[1186] - tr;
        data[1191] = data[1187] - ti;
        data[1186] += tr;
        data[1187] += ti;
    }
    // N = 4, at 1192
    {
        uniform float tr = data[1194];
        uniform float ti = data[1195];
        data[1194] = data[1192] - tr;
        data[1195] = data[1193] - ti;
        data[1192] += tr;
        data[1193] += ti;
        tr = data[1198];
        ti = data[1199];
        data[1198] = data[1197] - ti;
        data[1199] = tr - data[1196];
        data[1196] += tr;
        data[1197] += ti;
        tr = data[1196];
        ti = data[1197];
        data[1196] = data[1192] - tr;
        data[1197] = data[1193] - ti;
        data[1192] += tr;
        data[1193] += ti;
        tr = data[1198];
        ti = data[1199];
        data[1198] = data[1194] - tr;
        data[1199] = data[1195] - ti;
        data[1194] += tr;
        data[1195] += ti;
    }
    // N = 8, at 1184
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1192 ] * wr - data[ i + 1193 ] * wi;
            uniform float tempi  = data[ i + 1192 ] * wi + data[ i + 1193 ] * wr;
            uniform float tempr2 = data[ i + 1194 ] * wr2 - data[ i + 1195 ] * wi2;
            uniform float tempi2 = data[ i + 1194 ] * wi2 + data[ i + 1195 ] * wr2;
            data[ i + 1192 ] = data[ 1184 + i ] - tempr;
            data[ i + 1193 ] = data[ 1185 + i ] - tempi;
            data[ i + 1194 ] = data[ 1186 + i ] - tempr2;
            data[ i + 1195 ] = data[ 1187 + i ] - tempi2;
            data[ 1184 + i ] += tempr;
            data[ 1185 + i ] += tempi;
            data[ 1186 + i ] += tempr2;
            data[ 1187 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1200
    {
        uniform float tr = data[1202];
        uniform float ti = data[1203];
        data[1202] = data[1200] - tr;
        data[1203] = data[1201] - ti;
        data[1200] += tr;
        data[1201] += ti;
        tr = data[1206];
        ti = data[1207];
        data[1206] = data[1205] - ti;
        data[1207] = tr - data[1204];
        data[1204] += tr;
        data[1205] += ti;
        tr = data[1204];
        ti = data[1205];
        data[1204] = data[1200] - tr;
        data[1205] = data[1201] - ti;
        data[1200] += tr;
        data[1201] += ti;
        tr = data[1206];
        ti = data[1207];
        data[1206] = data[1202] - tr;
        data[1207] = data[1203] - ti;
        data[1202] += tr;
        data[1203] += ti;
    }
    // N = 4, at 1208
    {
        uniform float tr = data[1210];
        uniform float ti = data[1211];
        data[1210] = data[1208] - tr;
        data[1211] = data[1209] - ti;
        data[1208] += tr;
        data[1209] += ti;
        tr = data[1214];
        ti = data[1215];
        data[1214] = data[1213] - ti;
        data[1215] = tr - data[1212];
        data[1212] += tr;
        data[1213] += ti;
        tr = data[1212];
        ti = data[1213];
        data[1212] = data[1208] - tr;
        data[1213] = data[1209] - ti;
        data[1208] += tr;
        data[1209] += ti;
        tr = data[1214];
        ti = data[1215];
        data[1214] = data[1210] - tr;
        data[1215] = data[1211] - ti;
        data[1210] += tr;
        data[1211] += ti;
    }
    // N = 8, at 1200
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1208 ] * wr - data[ i + 1209 ] * wi;
            uniform float tempi  = data[ i + 1208 ] * wi + data[ i + 1209 ] * wr;
            uniform float tempr2 = data[ i + 1210 ] * wr2 - data[ i + 1211 ] * wi2;
            uniform float tempi2 = data[ i + 1210 ] * wi2 + data[ i + 1211 ] * wr2;
            data[ i + 1208 ] = data[ 1200 + i ] - tempr;
            data[ i + 1209 ] = data[ 1201 + i ] - tempi;
            data[ i + 1210 ] = data[ 1202 + i ] - tempr2;
            data[ i + 1211 ] = data[ 1203 + i ] - tempi2;
            data[ 1200 + i ] += tempr;
            data[ 1201 + i ] += tempi;
            data[ 1202 + i ] += tempr2;
            data[ 1203 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1184
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1200 ] * wr - data[ i + 1201 ] * wi;
            uniform float tempi  = data[ i + 1200 ] * wi + data[ i + 1201 ] * wr;
            uniform float tempr2 = data[ i + 1202 ] * wr2 - data[ i + 1203 ] * wi2;
            uniform float tempi2 = data[ i + 1202 ] * wi2 + data[ i + 1203 ] * wr2;
            data[ i + 1200 ] = data[ 1184 + i ] - tempr;
            data[ i + 1201 ] = data[ 1185 + i ] - tempi;
            data[ i + 1202 ] = data[ 1186 + i ] - tempr2;
            data[ i + 1203 ] = data[ 1187 + i ] - tempi2;
            data[ 1184 + i ] += tempr;
            data[ 1185 + i ] += tempi;
            data[ 1186 + i ] += tempr2;
            data[ 1187 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1152
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1184 ] * wr - data[ i + 1185 ] * wi;
            uniform float tempi  = data[ i + 1184 ] * wi + data[ i + 1185 ] * wr;
            uniform float tempr2 = data[ i + 1186 ] * wr2 - data[ i + 1187 ] * wi2;
            uniform float tempi2 = data[ i + 1186 ] * wi2 + data[ i + 1187 ] * wr2;
            data[ i + 1184 ] = data[ 1152 + i ] - tempr;
            data[ i + 1185 ] = data[ 1153 + i ] - tempi;
            data[ i + 1186 ] = data[ 1154 + i ] - tempr2;
            data[ i + 1187 ] = data[ 1155 + i ] - tempi2;
            data[ 1152 + i ] += tempr;
            data[ 1153 + i ] += tempi;
            data[ 1154 + i ] += tempr2;
            data[ 1155 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1216
    {
        uniform float tr = data[1218];
        uniform float ti = data[1219];
        data[1218] = data[1216] - tr;
        data[1219] = data[1217] - ti;
        data[1216] += tr;
        data[1217] += ti;
        tr = data[1222];
        ti = data[1223];
        data[1222] = data[1221] - ti;
        data[1223] = tr - data[1220];
        data[1220] += tr;
        data[1221] += ti;
        tr = data[1220];
        ti = data[1221];
        data[1220] = data[1216] - tr;
        data[1221] = data[1217] - ti;
        data[1216] += tr;
        data[1217] += ti;
        tr = data[1222];
        ti = data[1223];
        data[1222] = data[1218] - tr;
        data[1223] = data[1219] - ti;
        data[1218] += tr;
        data[1219] += ti;
    }
    // N = 4, at 1224
    {
        uniform float tr = data[1226];
        uniform float ti = data[1227];
        data[1226] = data[1224] - tr;
        data[1227] = data[1225] - ti;
        data[1224] += tr;
        data[1225] += ti;
        tr = data[1230];
        ti = data[1231];
        data[1230] = data[1229] - ti;
        data[1231] = tr - data[1228];
        data[1228] += tr;
        data[1229] += ti;
        tr = data[1228];
        ti = data[1229];
        data[1228] = data[1224] - tr;
        data[1229] = data[1225] - ti;
        data[1224] += tr;
        data[1225] += ti;
        tr = data[1230];
        ti = data[1231];
        data[1230] = data[1226] - tr;
        data[1231] = data[1227] - ti;
        data[1226] += tr;
        data[1227] += ti;
    }
    // N = 8, at 1216
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1224 ] * wr - data[ i + 1225 ] * wi;
            uniform float tempi  = data[ i + 1224 ] * wi + data[ i + 1225 ] * wr;
            uniform float tempr2 = data[ i + 1226 ] * wr2 - data[ i + 1227 ] * wi2;
            uniform float tempi2 = data[ i + 1226 ] * wi2 + data[ i + 1227 ] * wr2;
            data[ i + 1224 ] = data[ 1216 + i ] - tempr;
            data[ i + 1225 ] = data[ 1217 + i ] - tempi;
            data[ i + 1226 ] = data[ 1218 + i ] - tempr2;
            data[ i + 1227 ] = data[ 1219 + i ] - tempi2;
            data[ 1216 + i ] += tempr;
            data[ 1217 + i ] += tempi;
            data[ 1218 + i ] += tempr2;
            data[ 1219 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1232
    {
        uniform float tr = data[1234];
        uniform float ti = data[1235];
        data[1234] = data[1232] - tr;
        data[1235] = data[1233] - ti;
        data[1232] += tr;
        data[1233] += ti;
        tr = data[1238];
        ti = data[1239];
        data[1238] = data[1237] - ti;
        data[1239] = tr - data[1236];
        data[1236] += tr;
        data[1237] += ti;
        tr = data[1236];
        ti = data[1237];
        data[1236] = data[1232] - tr;
        data[1237] = data[1233] - ti;
        data[1232] += tr;
        data[1233] += ti;
        tr = data[1238];
        ti = data[1239];
        data[1238] = data[1234] - tr;
        data[1239] = data[1235] - ti;
        data[1234] += tr;
        data[1235] += ti;
    }
    // N = 4, at 1240
    {
        uniform float tr = data[1242];
        uniform float ti = data[1243];
        data[1242] = data[1240] - tr;
        data[1243] = data[1241] - ti;
        data[1240] += tr;
        data[1241] += ti;
        tr = data[1246];
        ti = data[1247];
        data[1246] = data[1245] - ti;
        data[1247] = tr - data[1244];
        data[1244] += tr;
        data[1245] += ti;
        tr = data[1244];
        ti = data[1245];
        data[1244] = data[1240] - tr;
        data[1245] = data[1241] - ti;
        data[1240] += tr;
        data[1241] += ti;
        tr = data[1246];
        ti = data[1247];
        data[1246] = data[1242] - tr;
        data[1247] = data[1243] - ti;
        data[1242] += tr;
        data[1243] += ti;
    }
    // N = 8, at 1232
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1240 ] * wr - data[ i + 1241 ] * wi;
            uniform float tempi  = data[ i + 1240 ] * wi + data[ i + 1241 ] * wr;
            uniform float tempr2 = data[ i + 1242 ] * wr2 - data[ i + 1243 ] * wi2;
            uniform float tempi2 = data[ i + 1242 ] * wi2 + data[ i + 1243 ] * wr2;
            data[ i + 1240 ] = data[ 1232 + i ] - tempr;
            data[ i + 1241 ] = data[ 1233 + i ] - tempi;
            data[ i + 1242 ] = data[ 1234 + i ] - tempr2;
            data[ i + 1243 ] = data[ 1235 + i ] - tempi2;
            data[ 1232 + i ] += tempr;
            data[ 1233 + i ] += tempi;
            data[ 1234 + i ] += tempr2;
            data[ 1235 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1216
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1232 ] * wr - data[ i + 1233 ] * wi;
            uniform float tempi  = data[ i + 1232 ] * wi + data[ i + 1233 ] * wr;
            uniform float tempr2 = data[ i + 1234 ] * wr2 - data[ i + 1235 ] * wi2;
            uniform float tempi2 = data[ i + 1234 ] * wi2 + data[ i + 1235 ] * wr2;
            data[ i + 1232 ] = data[ 1216 + i ] - tempr;
            data[ i + 1233 ] = data[ 1217 + i ] - tempi;
            data[ i + 1234 ] = data[ 1218 + i ] - tempr2;
            data[ i + 1235 ] = data[ 1219 + i ] - tempi2;
            data[ 1216 + i ] += tempr;
            data[ 1217 + i ] += tempi;
            data[ 1218 + i ] += tempr2;
            data[ 1219 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1248
    {
        uniform float tr = data[1250];
        uniform float ti = data[1251];
        data[1250] = data[1248] - tr;
        data[1251] = data[1249] - ti;
        data[1248] += tr;
        data[1249] += ti;
        tr = data[1254];
        ti = data[1255];
        data[1254] = data[1253] - ti;
        data[1255] = tr - data[1252];
        data[1252] += tr;
        data[1253] += ti;
        tr = data[1252];
        ti = data[1253];
        data[1252] = data[1248] - tr;
        data[1253] = data[1249] - ti;
        data[1248] += tr;
        data[1249] += ti;
        tr = data[1254];
        ti = data[1255];
        data[1254] = data[1250] - tr;
        data[1255] = data[1251] - ti;
        data[1250] += tr;
        data[1251] += ti;
    }
    // N = 4, at 1256
    {
        uniform float tr = data[1258];
        uniform float ti = data[1259];
        data[1258] = data[1256] - tr;
        data[1259] = data[1257] - ti;
        data[1256] += tr;
        data[1257] += ti;
        tr = data[1262];
        ti = data[1263];
        data[1262] = data[1261] - ti;
        data[1263] = tr - data[1260];
        data[1260] += tr;
        data[1261] += ti;
        tr = data[1260];
        ti = data[1261];
        data[1260] = data[1256] - tr;
        data[1261] = data[1257] - ti;
        data[1256] += tr;
        data[1257] += ti;
        tr = data[1262];
        ti = data[1263];
        data[1262] = data[1258] - tr;
        data[1263] = data[1259] - ti;
        data[1258] += tr;
        data[1259] += ti;
    }
    // N = 8, at 1248
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1256 ] * wr - data[ i + 1257 ] * wi;
            uniform float tempi  = data[ i + 1256 ] * wi + data[ i + 1257 ] * wr;
            uniform float tempr2 = data[ i + 1258 ] * wr2 - data[ i + 1259 ] * wi2;
            uniform float tempi2 = data[ i + 1258 ] * wi2 + data[ i + 1259 ] * wr2;
            data[ i + 1256 ] = data[ 1248 + i ] - tempr;
            data[ i + 1257 ] = data[ 1249 + i ] - tempi;
            data[ i + 1258 ] = data[ 1250 + i ] - tempr2;
            data[ i + 1259 ] = data[ 1251 + i ] - tempi2;
            data[ 1248 + i ] += tempr;
            data[ 1249 + i ] += tempi;
            data[ 1250 + i ] += tempr2;
            data[ 1251 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1264
    {
        uniform float tr = data[1266];
        uniform float ti = data[1267];
        data[1266] = data[1264] - tr;
        data[1267] = data[1265] - ti;
        data[1264] += tr;
        data[1265] += ti;
        tr = data[1270];
        ti = data[1271];
        data[1270] = data[1269] - ti;
        data[1271] = tr - data[1268];
        data[1268] += tr;
        data[1269] += ti;
        tr = data[1268];
        ti = data[1269];
        data[1268] = data[1264] - tr;
        data[1269] = data[1265] - ti;
        data[1264] += tr;
        data[1265] += ti;
        tr = data[1270];
        ti = data[1271];
        data[1270] = data[1266] - tr;
        data[1271] = data[1267] - ti;
        data[1266] += tr;
        data[1267] += ti;
    }
    // N = 4, at 1272
    {
        uniform float tr = data[1274];
        uniform float ti = data[1275];
        data[1274] = data[1272] - tr;
        data[1275] = data[1273] - ti;
        data[1272] += tr;
        data[1273] += ti;
        tr = data[1278];
        ti = data[1279];
        data[1278] = data[1277] - ti;
        data[1279] = tr - data[1276];
        data[1276] += tr;
        data[1277] += ti;
        tr = data[1276];
        ti = data[1277];
        data[1276] = data[1272] - tr;
        data[1277] = data[1273] - ti;
        data[1272] += tr;
        data[1273] += ti;
        tr = data[1278];
        ti = data[1279];
        data[1278] = data[1274] - tr;
        data[1279] = data[1275] - ti;
        data[1274] += tr;
        data[1275] += ti;
    }
    // N = 8, at 1264
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1272 ] * wr - data[ i + 1273 ] * wi;
            uniform float tempi  = data[ i + 1272 ] * wi + data[ i + 1273 ] * wr;
            uniform float tempr2 = data[ i + 1274 ] * wr2 - data[ i + 1275 ] * wi2;
            uniform float tempi2 = data[ i + 1274 ] * wi2 + data[ i + 1275 ] * wr2;
            data[ i + 1272 ] = data[ 1264 + i ] - tempr;
            data[ i + 1273 ] = data[ 1265 + i ] - tempi;
            data[ i + 1274 ] = data[ 1266 + i ] - tempr2;
            data[ i + 1275 ] = data[ 1267 + i ] - tempi2;
            data[ 1264 + i ] += tempr;
            data[ 1265 + i ] += tempi;
            data[ 1266 + i ] += tempr2;
            data[ 1267 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1248
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1264 ] * wr - data[ i + 1265 ] * wi;
            uniform float tempi  = data[ i + 1264 ] * wi + data[ i + 1265 ] * wr;
            uniform float tempr2 = data[ i + 1266 ] * wr2 - data[ i + 1267 ] * wi2;
            uniform float tempi2 = data[ i + 1266 ] * wi2 + data[ i + 1267 ] * wr2;
            data[ i + 1264 ] = data[ 1248 + i ] - tempr;
            data[ i + 1265 ] = data[ 1249 + i ] - tempi;
            data[ i + 1266 ] = data[ 1250 + i ] - tempr2;
            data[ i + 1267 ] = data[ 1251 + i ] - tempi2;
            data[ 1248 + i ] += tempr;
            data[ 1249 + i ] += tempi;
            data[ 1250 + i ] += tempr2;
            data[ 1251 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1216
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1248 ] * wr - data[ i + 1249 ] * wi;
            uniform float tempi  = data[ i + 1248 ] * wi + data[ i + 1249 ] * wr;
            uniform float tempr2 = data[ i + 1250 ] * wr2 - data[ i + 1251 ] * wi2;
            uniform float tempi2 = data[ i + 1250 ] * wi2 + data[ i + 1251 ] * wr2;
            data[ i + 1248 ] = data[ 1216 + i ] - tempr;
            data[ i + 1249 ] = data[ 1217 + i ] - tempi;
            data[ i + 1250 ] = data[ 1218 + i ] - tempr2;
            data[ i + 1251 ] = data[ 1219 + i ] - tempi2;
            data[ 1216 + i ] += tempr;
            data[ 1217 + i ] += tempi;
            data[ 1218 + i ] += tempr2;
            data[ 1219 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1152
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1216 ] * wr - data[ i + 1217 ] * wi;
            uniform float tempi  = data[ i + 1216 ] * wi + data[ i + 1217 ] * wr;
            uniform float tempr2 = data[ i + 1218 ] * wr2 - data[ i + 1219 ] * wi2;
            uniform float tempi2 = data[ i + 1218 ] * wi2 + data[ i + 1219 ] * wr2;
            data[ i + 1216 ] = data[ 1152 + i ] - tempr;
            data[ i + 1217 ] = data[ 1153 + i ] - tempi;
            data[ i + 1218 ] = data[ 1154 + i ] - tempr2;
            data[ i + 1219 ] = data[ 1155 + i ] - tempi2;
            data[ 1152 + i ] += tempr;
            data[ 1153 + i ] += tempi;
            data[ 1154 + i ] += tempr2;
            data[ 1155 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 1024
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1152 ] * wr - data[ i + 1153 ] * wi;
            uniform float tempi  = data[ i + 1152 ] * wi + data[ i + 1153 ] * wr;
            uniform float tempr2 = data[ i + 1154 ] * wr2 - data[ i + 1155 ] * wi2;
            uniform float tempi2 = data[ i + 1154 ] * wi2 + data[ i + 1155 ] * wr2;
            data[ i + 1152 ] = data[ 1024 + i ] - tempr;
            data[ i + 1153 ] = data[ 1025 + i ] - tempi;
            data[ i + 1154 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1155 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1280
    {
        uniform float tr = data[1282];
        uniform float ti = data[1283];
        data[1282] = data[1280] - tr;
        data[1283] = data[1281] - ti;
        data[1280] += tr;
        data[1281] += ti;
        tr = data[1286];
        ti = data[1287];
        data[1286] = data[1285] - ti;
        data[1287] = tr - data[1284];
        data[1284] += tr;
        data[1285] += ti;
        tr = data[1284];
        ti = data[1285];
        data[1284] = data[1280] - tr;
        data[1285] = data[1281] - ti;
        data[1280] += tr;
        data[1281] += ti;
        tr = data[1286];
        ti = data[1287];
        data[1286] = data[1282] - tr;
        data[1287] = data[1283] - ti;
        data[1282] += tr;
        data[1283] += ti;
    }
    // N = 4, at 1288
    {
        uniform float tr = data[1290];
        uniform float ti = data[1291];
        data[1290] = data[1288] - tr;
        data[1291] = data[1289] - ti;
        data[1288] += tr;
        data[1289] += ti;
        tr = data[1294];
        ti = data[1295];
        data[1294] = data[1293] - ti;
        data[1295] = tr - data[1292];
        data[1292] += tr;
        data[1293] += ti;
        tr = data[1292];
        ti = data[1293];
        data[1292] = data[1288] - tr;
        data[1293] = data[1289] - ti;
        data[1288] += tr;
        data[1289] += ti;
        tr = data[1294];
        ti = data[1295];
        data[1294] = data[1290] - tr;
        data[1295] = data[1291] - ti;
        data[1290] += tr;
        data[1291] += ti;
    }
    // N = 8, at 1280
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1288 ] * wr - data[ i + 1289 ] * wi;
            uniform float tempi  = data[ i + 1288 ] * wi + data[ i + 1289 ] * wr;
            uniform float tempr2 = data[ i + 1290 ] * wr2 - data[ i + 1291 ] * wi2;
            uniform float tempi2 = data[ i + 1290 ] * wi2 + data[ i + 1291 ] * wr2;
            data[ i + 1288 ] = data[ 1280 + i ] - tempr;
            data[ i + 1289 ] = data[ 1281 + i ] - tempi;
            data[ i + 1290 ] = data[ 1282 + i ] - tempr2;
            data[ i + 1291 ] = data[ 1283 + i ] - tempi2;
            data[ 1280 + i ] += tempr;
            data[ 1281 + i ] += tempi;
            data[ 1282 + i ] += tempr2;
            data[ 1283 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1296
    {
        uniform float tr = data[1298];
        uniform float ti = data[1299];
        data[1298] = data[1296] - tr;
        data[1299] = data[1297] - ti;
        data[1296] += tr;
        data[1297] += ti;
        tr = data[1302];
        ti = data[1303];
        data[1302] = data[1301] - ti;
        data[1303] = tr - data[1300];
        data[1300] += tr;
        data[1301] += ti;
        tr = data[1300];
        ti = data[1301];
        data[1300] = data[1296] - tr;
        data[1301] = data[1297] - ti;
        data[1296] += tr;
        data[1297] += ti;
        tr = data[1302];
        ti = data[1303];
        data[1302] = data[1298] - tr;
        data[1303] = data[1299] - ti;
        data[1298] += tr;
        data[1299] += ti;
    }
    // N = 4, at 1304
    {
        uniform float tr = data[1306];
        uniform float ti = data[1307];
        data[1306] = data[1304] - tr;
        data[1307] = data[1305] - ti;
        data[1304] += tr;
        data[1305] += ti;
        tr = data[1310];
        ti = data[1311];
        data[1310] = data[1309] - ti;
        data[1311] = tr - data[1308];
        data[1308] += tr;
        data[1309] += ti;
        tr = data[1308];
        ti = data[1309];
        data[1308] = data[1304] - tr;
        data[1309] = data[1305] - ti;
        data[1304] += tr;
        data[1305] += ti;
        tr = data[1310];
        ti = data[1311];
        data[1310] = data[1306] - tr;
        data[1311] = data[1307] - ti;
        data[1306] += tr;
        data[1307] += ti;
    }
    // N = 8, at 1296
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1304 ] * wr - data[ i + 1305 ] * wi;
            uniform float tempi  = data[ i + 1304 ] * wi + data[ i + 1305 ] * wr;
            uniform float tempr2 = data[ i + 1306 ] * wr2 - data[ i + 1307 ] * wi2;
            uniform float tempi2 = data[ i + 1306 ] * wi2 + data[ i + 1307 ] * wr2;
            data[ i + 1304 ] = data[ 1296 + i ] - tempr;
            data[ i + 1305 ] = data[ 1297 + i ] - tempi;
            data[ i + 1306 ] = data[ 1298 + i ] - tempr2;
            data[ i + 1307 ] = data[ 1299 + i ] - tempi2;
            data[ 1296 + i ] += tempr;
            data[ 1297 + i ] += tempi;
            data[ 1298 + i ] += tempr2;
            data[ 1299 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1280
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1296 ] * wr - data[ i + 1297 ] * wi;
            uniform float tempi  = data[ i + 1296 ] * wi + data[ i + 1297 ] * wr;
            uniform float tempr2 = data[ i + 1298 ] * wr2 - data[ i + 1299 ] * wi2;
            uniform float tempi2 = data[ i + 1298 ] * wi2 + data[ i + 1299 ] * wr2;
            data[ i + 1296 ] = data[ 1280 + i ] - tempr;
            data[ i + 1297 ] = data[ 1281 + i ] - tempi;
            data[ i + 1298 ] = data[ 1282 + i ] - tempr2;
            data[ i + 1299 ] = data[ 1283 + i ] - tempi2;
            data[ 1280 + i ] += tempr;
            data[ 1281 + i ] += tempi;
            data[ 1282 + i ] += tempr2;
            data[ 1283 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1312
    {
        uniform float tr = data[1314];
        uniform float ti = data[1315];
        data[1314] = data[1312] - tr;
        data[1315] = data[1313] - ti;
        data[1312] += tr;
        data[1313] += ti;
        tr = data[1318];
        ti = data[1319];
        data[1318] = data[1317] - ti;
        data[1319] = tr - data[1316];
        data[1316] += tr;
        data[1317] += ti;
        tr = data[1316];
        ti = data[1317];
        data[1316] = data[1312] - tr;
        data[1317] = data[1313] - ti;
        data[1312] += tr;
        data[1313] += ti;
        tr = data[1318];
        ti = data[1319];
        data[1318] = data[1314] - tr;
        data[1319] = data[1315] - ti;
        data[1314] += tr;
        data[1315] += ti;
    }
    // N = 4, at 1320
    {
        uniform float tr = data[1322];
        uniform float ti = data[1323];
        data[1322] = data[1320] - tr;
        data[1323] = data[1321] - ti;
        data[1320] += tr;
        data[1321] += ti;
        tr = data[1326];
        ti = data[1327];
        data[1326] = data[1325] - ti;
        data[1327] = tr - data[1324];
        data[1324] += tr;
        data[1325] += ti;
        tr = data[1324];
        ti = data[1325];
        data[1324] = data[1320] - tr;
        data[1325] = data[1321] - ti;
        data[1320] += tr;
        data[1321] += ti;
        tr = data[1326];
        ti = data[1327];
        data[1326] = data[1322] - tr;
        data[1327] = data[1323] - ti;
        data[1322] += tr;
        data[1323] += ti;
    }
    // N = 8, at 1312
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1320 ] * wr - data[ i + 1321 ] * wi;
            uniform float tempi  = data[ i + 1320 ] * wi + data[ i + 1321 ] * wr;
            uniform float tempr2 = data[ i + 1322 ] * wr2 - data[ i + 1323 ] * wi2;
            uniform float tempi2 = data[ i + 1322 ] * wi2 + data[ i + 1323 ] * wr2;
            data[ i + 1320 ] = data[ 1312 + i ] - tempr;
            data[ i + 1321 ] = data[ 1313 + i ] - tempi;
            data[ i + 1322 ] = data[ 1314 + i ] - tempr2;
            data[ i + 1323 ] = data[ 1315 + i ] - tempi2;
            data[ 1312 + i ] += tempr;
            data[ 1313 + i ] += tempi;
            data[ 1314 + i ] += tempr2;
            data[ 1315 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1328
    {
        uniform float tr = data[1330];
        uniform float ti = data[1331];
        data[1330] = data[1328] - tr;
        data[1331] = data[1329] - ti;
        data[1328] += tr;
        data[1329] += ti;
        tr = data[1334];
        ti = data[1335];
        data[1334] = data[1333] - ti;
        data[1335] = tr - data[1332];
        data[1332] += tr;
        data[1333] += ti;
        tr = data[1332];
        ti = data[1333];
        data[1332] = data[1328] - tr;
        data[1333] = data[1329] - ti;
        data[1328] += tr;
        data[1329] += ti;
        tr = data[1334];
        ti = data[1335];
        data[1334] = data[1330] - tr;
        data[1335] = data[1331] - ti;
        data[1330] += tr;
        data[1331] += ti;
    }
    // N = 4, at 1336
    {
        uniform float tr = data[1338];
        uniform float ti = data[1339];
        data[1338] = data[1336] - tr;
        data[1339] = data[1337] - ti;
        data[1336] += tr;
        data[1337] += ti;
        tr = data[1342];
        ti = data[1343];
        data[1342] = data[1341] - ti;
        data[1343] = tr - data[1340];
        data[1340] += tr;
        data[1341] += ti;
        tr = data[1340];
        ti = data[1341];
        data[1340] = data[1336] - tr;
        data[1341] = data[1337] - ti;
        data[1336] += tr;
        data[1337] += ti;
        tr = data[1342];
        ti = data[1343];
        data[1342] = data[1338] - tr;
        data[1343] = data[1339] - ti;
        data[1338] += tr;
        data[1339] += ti;
    }
    // N = 8, at 1328
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1336 ] * wr - data[ i + 1337 ] * wi;
            uniform float tempi  = data[ i + 1336 ] * wi + data[ i + 1337 ] * wr;
            uniform float tempr2 = data[ i + 1338 ] * wr2 - data[ i + 1339 ] * wi2;
            uniform float tempi2 = data[ i + 1338 ] * wi2 + data[ i + 1339 ] * wr2;
            data[ i + 1336 ] = data[ 1328 + i ] - tempr;
            data[ i + 1337 ] = data[ 1329 + i ] - tempi;
            data[ i + 1338 ] = data[ 1330 + i ] - tempr2;
            data[ i + 1339 ] = data[ 1331 + i ] - tempi2;
            data[ 1328 + i ] += tempr;
            data[ 1329 + i ] += tempi;
            data[ 1330 + i ] += tempr2;
            data[ 1331 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1312
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1328 ] * wr - data[ i + 1329 ] * wi;
            uniform float tempi  = data[ i + 1328 ] * wi + data[ i + 1329 ] * wr;
            uniform float tempr2 = data[ i + 1330 ] * wr2 - data[ i + 1331 ] * wi2;
            uniform float tempi2 = data[ i + 1330 ] * wi2 + data[ i + 1331 ] * wr2;
            data[ i + 1328 ] = data[ 1312 + i ] - tempr;
            data[ i + 1329 ] = data[ 1313 + i ] - tempi;
            data[ i + 1330 ] = data[ 1314 + i ] - tempr2;
            data[ i + 1331 ] = data[ 1315 + i ] - tempi2;
            data[ 1312 + i ] += tempr;
            data[ 1313 + i ] += tempi;
            data[ 1314 + i ] += tempr2;
            data[ 1315 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1280
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1312 ] * wr - data[ i + 1313 ] * wi;
            uniform float tempi  = data[ i + 1312 ] * wi + data[ i + 1313 ] * wr;
            uniform float tempr2 = data[ i + 1314 ] * wr2 - data[ i + 1315 ] * wi2;
            uniform float tempi2 = data[ i + 1314 ] * wi2 + data[ i + 1315 ] * wr2;
            data[ i + 1312 ] = data[ 1280 + i ] - tempr;
            data[ i + 1313 ] = data[ 1281 + i ] - tempi;
            data[ i + 1314 ] = data[ 1282 + i ] - tempr2;
            data[ i + 1315 ] = data[ 1283 + i ] - tempi2;
            data[ 1280 + i ] += tempr;
            data[ 1281 + i ] += tempi;
            data[ 1282 + i ] += tempr2;
            data[ 1283 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1344
    {
        uniform float tr = data[1346];
        uniform float ti = data[1347];
        data[1346] = data[1344] - tr;
        data[1347] = data[1345] - ti;
        data[1344] += tr;
        data[1345] += ti;
        tr = data[1350];
        ti = data[1351];
        data[1350] = data[1349] - ti;
        data[1351] = tr - data[1348];
        data[1348] += tr;
        data[1349] += ti;
        tr = data[1348];
        ti = data[1349];
        data[1348] = data[1344] - tr;
        data[1349] = data[1345] - ti;
        data[1344] += tr;
        data[1345] += ti;
        tr = data[1350];
        ti = data[1351];
        data[1350] = data[1346] - tr;
        data[1351] = data[1347] - ti;
        data[1346] += tr;
        data[1347] += ti;
    }
    // N = 4, at 1352
    {
        uniform float tr = data[1354];
        uniform float ti = data[1355];
        data[1354] = data[1352] - tr;
        data[1355] = data[1353] - ti;
        data[1352] += tr;
        data[1353] += ti;
        tr = data[1358];
        ti = data[1359];
        data[1358] = data[1357] - ti;
        data[1359] = tr - data[1356];
        data[1356] += tr;
        data[1357] += ti;
        tr = data[1356];
        ti = data[1357];
        data[1356] = data[1352] - tr;
        data[1357] = data[1353] - ti;
        data[1352] += tr;
        data[1353] += ti;
        tr = data[1358];
        ti = data[1359];
        data[1358] = data[1354] - tr;
        data[1359] = data[1355] - ti;
        data[1354] += tr;
        data[1355] += ti;
    }
    // N = 8, at 1344
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1352 ] * wr - data[ i + 1353 ] * wi;
            uniform float tempi  = data[ i + 1352 ] * wi + data[ i + 1353 ] * wr;
            uniform float tempr2 = data[ i + 1354 ] * wr2 - data[ i + 1355 ] * wi2;
            uniform float tempi2 = data[ i + 1354 ] * wi2 + data[ i + 1355 ] * wr2;
            data[ i + 1352 ] = data[ 1344 + i ] - tempr;
            data[ i + 1353 ] = data[ 1345 + i ] - tempi;
            data[ i + 1354 ] = data[ 1346 + i ] - tempr2;
            data[ i + 1355 ] = data[ 1347 + i ] - tempi2;
            data[ 1344 + i ] += tempr;
            data[ 1345 + i ] += tempi;
            data[ 1346 + i ] += tempr2;
            data[ 1347 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1360
    {
        uniform float tr = data[1362];
        uniform float ti = data[1363];
        data[1362] = data[1360] - tr;
        data[1363] = data[1361] - ti;
        data[1360] += tr;
        data[1361] += ti;
        tr = data[1366];
        ti = data[1367];
        data[1366] = data[1365] - ti;
        data[1367] = tr - data[1364];
        data[1364] += tr;
        data[1365] += ti;
        tr = data[1364];
        ti = data[1365];
        data[1364] = data[1360] - tr;
        data[1365] = data[1361] - ti;
        data[1360] += tr;
        data[1361] += ti;
        tr = data[1366];
        ti = data[1367];
        data[1366] = data[1362] - tr;
        data[1367] = data[1363] - ti;
        data[1362] += tr;
        data[1363] += ti;
    }
    // N = 4, at 1368
    {
        uniform float tr = data[1370];
        uniform float ti = data[1371];
        data[1370] = data[1368] - tr;
        data[1371] = data[1369] - ti;
        data[1368] += tr;
        data[1369] += ti;
        tr = data[1374];
        ti = data[1375];
        data[1374] = data[1373] - ti;
        data[1375] = tr - data[1372];
        data[1372] += tr;
        data[1373] += ti;
        tr = data[1372];
        ti = data[1373];
        data[1372] = data[1368] - tr;
        data[1373] = data[1369] - ti;
        data[1368] += tr;
        data[1369] += ti;
        tr = data[1374];
        ti = data[1375];
        data[1374] = data[1370] - tr;
        data[1375] = data[1371] - ti;
        data[1370] += tr;
        data[1371] += ti;
    }
    // N = 8, at 1360
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1368 ] * wr - data[ i + 1369 ] * wi;
            uniform float tempi  = data[ i + 1368 ] * wi + data[ i + 1369 ] * wr;
            uniform float tempr2 = data[ i + 1370 ] * wr2 - data[ i + 1371 ] * wi2;
            uniform float tempi2 = data[ i + 1370 ] * wi2 + data[ i + 1371 ] * wr2;
            data[ i + 1368 ] = data[ 1360 + i ] - tempr;
            data[ i + 1369 ] = data[ 1361 + i ] - tempi;
            data[ i + 1370 ] = data[ 1362 + i ] - tempr2;
            data[ i + 1371 ] = data[ 1363 + i ] - tempi2;
            data[ 1360 + i ] += tempr;
            data[ 1361 + i ] += tempi;
            data[ 1362 + i ] += tempr2;
            data[ 1363 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1344
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1360 ] * wr - data[ i + 1361 ] * wi;
            uniform float tempi  = data[ i + 1360 ] * wi + data[ i + 1361 ] * wr;
            uniform float tempr2 = data[ i + 1362 ] * wr2 - data[ i + 1363 ] * wi2;
            uniform float tempi2 = data[ i + 1362 ] * wi2 + data[ i + 1363 ] * wr2;
            data[ i + 1360 ] = data[ 1344 + i ] - tempr;
            data[ i + 1361 ] = data[ 1345 + i ] - tempi;
            data[ i + 1362 ] = data[ 1346 + i ] - tempr2;
            data[ i + 1363 ] = data[ 1347 + i ] - tempi2;
            data[ 1344 + i ] += tempr;
            data[ 1345 + i ] += tempi;
            data[ 1346 + i ] += tempr2;
            data[ 1347 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1376
    {
        uniform float tr = data[1378];
        uniform float ti = data[1379];
        data[1378] = data[1376] - tr;
        data[1379] = data[1377] - ti;
        data[1376] += tr;
        data[1377] += ti;
        tr = data[1382];
        ti = data[1383];
        data[1382] = data[1381] - ti;
        data[1383] = tr - data[1380];
        data[1380] += tr;
        data[1381] += ti;
        tr = data[1380];
        ti = data[1381];
        data[1380] = data[1376] - tr;
        data[1381] = data[1377] - ti;
        data[1376] += tr;
        data[1377] += ti;
        tr = data[1382];
        ti = data[1383];
        data[1382] = data[1378] - tr;
        data[1383] = data[1379] - ti;
        data[1378] += tr;
        data[1379] += ti;
    }
    // N = 4, at 1384
    {
        uniform float tr = data[1386];
        uniform float ti = data[1387];
        data[1386] = data[1384] - tr;
        data[1387] = data[1385] - ti;
        data[1384] += tr;
        data[1385] += ti;
        tr = data[1390];
        ti = data[1391];
        data[1390] = data[1389] - ti;
        data[1391] = tr - data[1388];
        data[1388] += tr;
        data[1389] += ti;
        tr = data[1388];
        ti = data[1389];
        data[1388] = data[1384] - tr;
        data[1389] = data[1385] - ti;
        data[1384] += tr;
        data[1385] += ti;
        tr = data[1390];
        ti = data[1391];
        data[1390] = data[1386] - tr;
        data[1391] = data[1387] - ti;
        data[1386] += tr;
        data[1387] += ti;
    }
    // N = 8, at 1376
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1384 ] * wr - data[ i + 1385 ] * wi;
            uniform float tempi  = data[ i + 1384 ] * wi + data[ i + 1385 ] * wr;
            uniform float tempr2 = data[ i + 1386 ] * wr2 - data[ i + 1387 ] * wi2;
            uniform float tempi2 = data[ i + 1386 ] * wi2 + data[ i + 1387 ] * wr2;
            data[ i + 1384 ] = data[ 1376 + i ] - tempr;
            data[ i + 1385 ] = data[ 1377 + i ] - tempi;
            data[ i + 1386 ] = data[ 1378 + i ] - tempr2;
            data[ i + 1387 ] = data[ 1379 + i ] - tempi2;
            data[ 1376 + i ] += tempr;
            data[ 1377 + i ] += tempi;
            data[ 1378 + i ] += tempr2;
            data[ 1379 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1392
    {
        uniform float tr = data[1394];
        uniform float ti = data[1395];
        data[1394] = data[1392] - tr;
        data[1395] = data[1393] - ti;
        data[1392] += tr;
        data[1393] += ti;
        tr = data[1398];
        ti = data[1399];
        data[1398] = data[1397] - ti;
        data[1399] = tr - data[1396];
        data[1396] += tr;
        data[1397] += ti;
        tr = data[1396];
        ti = data[1397];
        data[1396] = data[1392] - tr;
        data[1397] = data[1393] - ti;
        data[1392] += tr;
        data[1393] += ti;
        tr = data[1398];
        ti = data[1399];
        data[1398] = data[1394] - tr;
        data[1399] = data[1395] - ti;
        data[1394] += tr;
        data[1395] += ti;
    }
    // N = 4, at 1400
    {
        uniform float tr = data[1402];
        uniform float ti = data[1403];
        data[1402] = data[1400] - tr;
        data[1403] = data[1401] - ti;
        data[1400] += tr;
        data[1401] += ti;
        tr = data[1406];
        ti = data[1407];
        data[1406] = data[1405] - ti;
        data[1407] = tr - data[1404];
        data[1404] += tr;
        data[1405] += ti;
        tr = data[1404];
        ti = data[1405];
        data[1404] = data[1400] - tr;
        data[1405] = data[1401] - ti;
        data[1400] += tr;
        data[1401] += ti;
        tr = data[1406];
        ti = data[1407];
        data[1406] = data[1402] - tr;
        data[1407] = data[1403] - ti;
        data[1402] += tr;
        data[1403] += ti;
    }
    // N = 8, at 1392
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1400 ] * wr - data[ i + 1401 ] * wi;
            uniform float tempi  = data[ i + 1400 ] * wi + data[ i + 1401 ] * wr;
            uniform float tempr2 = data[ i + 1402 ] * wr2 - data[ i + 1403 ] * wi2;
            uniform float tempi2 = data[ i + 1402 ] * wi2 + data[ i + 1403 ] * wr2;
            data[ i + 1400 ] = data[ 1392 + i ] - tempr;
            data[ i + 1401 ] = data[ 1393 + i ] - tempi;
            data[ i + 1402 ] = data[ 1394 + i ] - tempr2;
            data[ i + 1403 ] = data[ 1395 + i ] - tempi2;
            data[ 1392 + i ] += tempr;
            data[ 1393 + i ] += tempi;
            data[ 1394 + i ] += tempr2;
            data[ 1395 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1376
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1392 ] * wr - data[ i + 1393 ] * wi;
            uniform float tempi  = data[ i + 1392 ] * wi + data[ i + 1393 ] * wr;
            uniform float tempr2 = data[ i + 1394 ] * wr2 - data[ i + 1395 ] * wi2;
            uniform float tempi2 = data[ i + 1394 ] * wi2 + data[ i + 1395 ] * wr2;
            data[ i + 1392 ] = data[ 1376 + i ] - tempr;
            data[ i + 1393 ] = data[ 1377 + i ] - tempi;
            data[ i + 1394 ] = data[ 1378 + i ] - tempr2;
            data[ i + 1395 ] = data[ 1379 + i ] - tempi2;
            data[ 1376 + i ] += tempr;
            data[ 1377 + i ] += tempi;
            data[ 1378 + i ] += tempr2;
            data[ 1379 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1344
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1376 ] * wr - data[ i + 1377 ] * wi;
            uniform float tempi  = data[ i + 1376 ] * wi + data[ i + 1377 ] * wr;
            uniform float tempr2 = data[ i + 1378 ] * wr2 - data[ i + 1379 ] * wi2;
            uniform float tempi2 = data[ i + 1378 ] * wi2 + data[ i + 1379 ] * wr2;
            data[ i + 1376 ] = data[ 1344 + i ] - tempr;
            data[ i + 1377 ] = data[ 1345 + i ] - tempi;
            data[ i + 1378 ] = data[ 1346 + i ] - tempr2;
            data[ i + 1379 ] = data[ 1347 + i ] - tempi2;
            data[ 1344 + i ] += tempr;
            data[ 1345 + i ] += tempi;
            data[ 1346 + i ] += tempr2;
            data[ 1347 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1280
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1344 ] * wr - data[ i + 1345 ] * wi;
            uniform float tempi  = data[ i + 1344 ] * wi + data[ i + 1345 ] * wr;
            uniform float tempr2 = data[ i + 1346 ] * wr2 - data[ i + 1347 ] * wi2;
            uniform float tempi2 = data[ i + 1346 ] * wi2 + data[ i + 1347 ] * wr2;
            data[ i + 1344 ] = data[ 1280 + i ] - tempr;
            data[ i + 1345 ] = data[ 1281 + i ] - tempi;
            data[ i + 1346 ] = data[ 1282 + i ] - tempr2;
            data[ i + 1347 ] = data[ 1283 + i ] - tempi2;
            data[ 1280 + i ] += tempr;
            data[ 1281 + i ] += tempi;
            data[ 1282 + i ] += tempr2;
            data[ 1283 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1408
    {
        uniform float tr = data[1410];
        uniform float ti = data[1411];
        data[1410] = data[1408] - tr;
        data[1411] = data[1409] - ti;
        data[1408] += tr;
        data[1409] += ti;
        tr = data[1414];
        ti = data[1415];
        data[1414] = data[1413] - ti;
        data[1415] = tr - data[1412];
        data[1412] += tr;
        data[1413] += ti;
        tr = data[1412];
        ti = data[1413];
        data[1412] = data[1408] - tr;
        data[1413] = data[1409] - ti;
        data[1408] += tr;
        data[1409] += ti;
        tr = data[1414];
        ti = data[1415];
        data[1414] = data[1410] - tr;
        data[1415] = data[1411] - ti;
        data[1410] += tr;
        data[1411] += ti;
    }
    // N = 4, at 1416
    {
        uniform float tr = data[1418];
        uniform float ti = data[1419];
        data[1418] = data[1416] - tr;
        data[1419] = data[1417] - ti;
        data[1416] += tr;
        data[1417] += ti;
        tr = data[1422];
        ti = data[1423];
        data[1422] = data[1421] - ti;
        data[1423] = tr - data[1420];
        data[1420] += tr;
        data[1421] += ti;
        tr = data[1420];
        ti = data[1421];
        data[1420] = data[1416] - tr;
        data[1421] = data[1417] - ti;
        data[1416] += tr;
        data[1417] += ti;
        tr = data[1422];
        ti = data[1423];
        data[1422] = data[1418] - tr;
        data[1423] = data[1419] - ti;
        data[1418] += tr;
        data[1419] += ti;
    }
    // N = 8, at 1408
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1416 ] * wr - data[ i + 1417 ] * wi;
            uniform float tempi  = data[ i + 1416 ] * wi + data[ i + 1417 ] * wr;
            uniform float tempr2 = data[ i + 1418 ] * wr2 - data[ i + 1419 ] * wi2;
            uniform float tempi2 = data[ i + 1418 ] * wi2 + data[ i + 1419 ] * wr2;
            data[ i + 1416 ] = data[ 1408 + i ] - tempr;
            data[ i + 1417 ] = data[ 1409 + i ] - tempi;
            data[ i + 1418 ] = data[ 1410 + i ] - tempr2;
            data[ i + 1419 ] = data[ 1411 + i ] - tempi2;
            data[ 1408 + i ] += tempr;
            data[ 1409 + i ] += tempi;
            data[ 1410 + i ] += tempr2;
            data[ 1411 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1424
    {
        uniform float tr = data[1426];
        uniform float ti = data[1427];
        data[1426] = data[1424] - tr;
        data[1427] = data[1425] - ti;
        data[1424] += tr;
        data[1425] += ti;
        tr = data[1430];
        ti = data[1431];
        data[1430] = data[1429] - ti;
        data[1431] = tr - data[1428];
        data[1428] += tr;
        data[1429] += ti;
        tr = data[1428];
        ti = data[1429];
        data[1428] = data[1424] - tr;
        data[1429] = data[1425] - ti;
        data[1424] += tr;
        data[1425] += ti;
        tr = data[1430];
        ti = data[1431];
        data[1430] = data[1426] - tr;
        data[1431] = data[1427] - ti;
        data[1426] += tr;
        data[1427] += ti;
    }
    // N = 4, at 1432
    {
        uniform float tr = data[1434];
        uniform float ti = data[1435];
        data[1434] = data[1432] - tr;
        data[1435] = data[1433] - ti;
        data[1432] += tr;
        data[1433] += ti;
        tr = data[1438];
        ti = data[1439];
        data[1438] = data[1437] - ti;
        data[1439] = tr - data[1436];
        data[1436] += tr;
        data[1437] += ti;
        tr = data[1436];
        ti = data[1437];
        data[1436] = data[1432] - tr;
        data[1437] = data[1433] - ti;
        data[1432] += tr;
        data[1433] += ti;
        tr = data[1438];
        ti = data[1439];
        data[1438] = data[1434] - tr;
        data[1439] = data[1435] - ti;
        data[1434] += tr;
        data[1435] += ti;
    }
    // N = 8, at 1424
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1432 ] * wr - data[ i + 1433 ] * wi;
            uniform float tempi  = data[ i + 1432 ] * wi + data[ i + 1433 ] * wr;
            uniform float tempr2 = data[ i + 1434 ] * wr2 - data[ i + 1435 ] * wi2;
            uniform float tempi2 = data[ i + 1434 ] * wi2 + data[ i + 1435 ] * wr2;
            data[ i + 1432 ] = data[ 1424 + i ] - tempr;
            data[ i + 1433 ] = data[ 1425 + i ] - tempi;
            data[ i + 1434 ] = data[ 1426 + i ] - tempr2;
            data[ i + 1435 ] = data[ 1427 + i ] - tempi2;
            data[ 1424 + i ] += tempr;
            data[ 1425 + i ] += tempi;
            data[ 1426 + i ] += tempr2;
            data[ 1427 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1408
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1424 ] * wr - data[ i + 1425 ] * wi;
            uniform float tempi  = data[ i + 1424 ] * wi + data[ i + 1425 ] * wr;
            uniform float tempr2 = data[ i + 1426 ] * wr2 - data[ i + 1427 ] * wi2;
            uniform float tempi2 = data[ i + 1426 ] * wi2 + data[ i + 1427 ] * wr2;
            data[ i + 1424 ] = data[ 1408 + i ] - tempr;
            data[ i + 1425 ] = data[ 1409 + i ] - tempi;
            data[ i + 1426 ] = data[ 1410 + i ] - tempr2;
            data[ i + 1427 ] = data[ 1411 + i ] - tempi2;
            data[ 1408 + i ] += tempr;
            data[ 1409 + i ] += tempi;
            data[ 1410 + i ] += tempr2;
            data[ 1411 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1440
    {
        uniform float tr = data[1442];
        uniform float ti = data[1443];
        data[1442] = data[1440] - tr;
        data[1443] = data[1441] - ti;
        data[1440] += tr;
        data[1441] += ti;
        tr = data[1446];
        ti = data[1447];
        data[1446] = data[1445] - ti;
        data[1447] = tr - data[1444];
        data[1444] += tr;
        data[1445] += ti;
        tr = data[1444];
        ti = data[1445];
        data[1444] = data[1440] - tr;
        data[1445] = data[1441] - ti;
        data[1440] += tr;
        data[1441] += ti;
        tr = data[1446];
        ti = data[1447];
        data[1446] = data[1442] - tr;
        data[1447] = data[1443] - ti;
        data[1442] += tr;
        data[1443] += ti;
    }
    // N = 4, at 1448
    {
        uniform float tr = data[1450];
        uniform float ti = data[1451];
        data[1450] = data[1448] - tr;
        data[1451] = data[1449] - ti;
        data[1448] += tr;
        data[1449] += ti;
        tr = data[1454];
        ti = data[1455];
        data[1454] = data[1453] - ti;
        data[1455] = tr - data[1452];
        data[1452] += tr;
        data[1453] += ti;
        tr = data[1452];
        ti = data[1453];
        data[1452] = data[1448] - tr;
        data[1453] = data[1449] - ti;
        data[1448] += tr;
        data[1449] += ti;
        tr = data[1454];
        ti = data[1455];
        data[1454] = data[1450] - tr;
        data[1455] = data[1451] - ti;
        data[1450] += tr;
        data[1451] += ti;
    }
    // N = 8, at 1440
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1448 ] * wr - data[ i + 1449 ] * wi;
            uniform float tempi  = data[ i + 1448 ] * wi + data[ i + 1449 ] * wr;
            uniform float tempr2 = data[ i + 1450 ] * wr2 - data[ i + 1451 ] * wi2;
            uniform float tempi2 = data[ i + 1450 ] * wi2 + data[ i + 1451 ] * wr2;
            data[ i + 1448 ] = data[ 1440 + i ] - tempr;
            data[ i + 1449 ] = data[ 1441 + i ] - tempi;
            data[ i + 1450 ] = data[ 1442 + i ] - tempr2;
            data[ i + 1451 ] = data[ 1443 + i ] - tempi2;
            data[ 1440 + i ] += tempr;
            data[ 1441 + i ] += tempi;
            data[ 1442 + i ] += tempr2;
            data[ 1443 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1456
    {
        uniform float tr = data[1458];
        uniform float ti = data[1459];
        data[1458] = data[1456] - tr;
        data[1459] = data[1457] - ti;
        data[1456] += tr;
        data[1457] += ti;
        tr = data[1462];
        ti = data[1463];
        data[1462] = data[1461] - ti;
        data[1463] = tr - data[1460];
        data[1460] += tr;
        data[1461] += ti;
        tr = data[1460];
        ti = data[1461];
        data[1460] = data[1456] - tr;
        data[1461] = data[1457] - ti;
        data[1456] += tr;
        data[1457] += ti;
        tr = data[1462];
        ti = data[1463];
        data[1462] = data[1458] - tr;
        data[1463] = data[1459] - ti;
        data[1458] += tr;
        data[1459] += ti;
    }
    // N = 4, at 1464
    {
        uniform float tr = data[1466];
        uniform float ti = data[1467];
        data[1466] = data[1464] - tr;
        data[1467] = data[1465] - ti;
        data[1464] += tr;
        data[1465] += ti;
        tr = data[1470];
        ti = data[1471];
        data[1470] = data[1469] - ti;
        data[1471] = tr - data[1468];
        data[1468] += tr;
        data[1469] += ti;
        tr = data[1468];
        ti = data[1469];
        data[1468] = data[1464] - tr;
        data[1469] = data[1465] - ti;
        data[1464] += tr;
        data[1465] += ti;
        tr = data[1470];
        ti = data[1471];
        data[1470] = data[1466] - tr;
        data[1471] = data[1467] - ti;
        data[1466] += tr;
        data[1467] += ti;
    }
    // N = 8, at 1456
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1464 ] * wr - data[ i + 1465 ] * wi;
            uniform float tempi  = data[ i + 1464 ] * wi + data[ i + 1465 ] * wr;
            uniform float tempr2 = data[ i + 1466 ] * wr2 - data[ i + 1467 ] * wi2;
            uniform float tempi2 = data[ i + 1466 ] * wi2 + data[ i + 1467 ] * wr2;
            data[ i + 1464 ] = data[ 1456 + i ] - tempr;
            data[ i + 1465 ] = data[ 1457 + i ] - tempi;
            data[ i + 1466 ] = data[ 1458 + i ] - tempr2;
            data[ i + 1467 ] = data[ 1459 + i ] - tempi2;
            data[ 1456 + i ] += tempr;
            data[ 1457 + i ] += tempi;
            data[ 1458 + i ] += tempr2;
            data[ 1459 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1440
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1456 ] * wr - data[ i + 1457 ] * wi;
            uniform float tempi  = data[ i + 1456 ] * wi + data[ i + 1457 ] * wr;
            uniform float tempr2 = data[ i + 1458 ] * wr2 - data[ i + 1459 ] * wi2;
            uniform float tempi2 = data[ i + 1458 ] * wi2 + data[ i + 1459 ] * wr2;
            data[ i + 1456 ] = data[ 1440 + i ] - tempr;
            data[ i + 1457 ] = data[ 1441 + i ] - tempi;
            data[ i + 1458 ] = data[ 1442 + i ] - tempr2;
            data[ i + 1459 ] = data[ 1443 + i ] - tempi2;
            data[ 1440 + i ] += tempr;
            data[ 1441 + i ] += tempi;
            data[ 1442 + i ] += tempr2;
            data[ 1443 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1408
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1440 ] * wr - data[ i + 1441 ] * wi;
            uniform float tempi  = data[ i + 1440 ] * wi + data[ i + 1441 ] * wr;
            uniform float tempr2 = data[ i + 1442 ] * wr2 - data[ i + 1443 ] * wi2;
            uniform float tempi2 = data[ i + 1442 ] * wi2 + data[ i + 1443 ] * wr2;
            data[ i + 1440 ] = data[ 1408 + i ] - tempr;
            data[ i + 1441 ] = data[ 1409 + i ] - tempi;
            data[ i + 1442 ] = data[ 1410 + i ] - tempr2;
            data[ i + 1443 ] = data[ 1411 + i ] - tempi2;
            data[ 1408 + i ] += tempr;
            data[ 1409 + i ] += tempi;
            data[ 1410 + i ] += tempr2;
            data[ 1411 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1472
    {
        uniform float tr = data[1474];
        uniform float ti = data[1475];
        data[1474] = data[1472] - tr;
        data[1475] = data[1473] - ti;
        data[1472] += tr;
        data[1473] += ti;
        tr = data[1478];
        ti = data[1479];
        data[1478] = data[1477] - ti;
        data[1479] = tr - data[1476];
        data[1476] += tr;
        data[1477] += ti;
        tr = data[1476];
        ti = data[1477];
        data[1476] = data[1472] - tr;
        data[1477] = data[1473] - ti;
        data[1472] += tr;
        data[1473] += ti;
        tr = data[1478];
        ti = data[1479];
        data[1478] = data[1474] - tr;
        data[1479] = data[1475] - ti;
        data[1474] += tr;
        data[1475] += ti;
    }
    // N = 4, at 1480
    {
        uniform float tr = data[1482];
        uniform float ti = data[1483];
        data[1482] = data[1480] - tr;
        data[1483] = data[1481] - ti;
        data[1480] += tr;
        data[1481] += ti;
        tr = data[1486];
        ti = data[1487];
        data[1486] = data[1485] - ti;
        data[1487] = tr - data[1484];
        data[1484] += tr;
        data[1485] += ti;
        tr = data[1484];
        ti = data[1485];
        data[1484] = data[1480] - tr;
        data[1485] = data[1481] - ti;
        data[1480] += tr;
        data[1481] += ti;
        tr = data[1486];
        ti = data[1487];
        data[1486] = data[1482] - tr;
        data[1487] = data[1483] - ti;
        data[1482] += tr;
        data[1483] += ti;
    }
    // N = 8, at 1472
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1480 ] * wr - data[ i + 1481 ] * wi;
            uniform float tempi  = data[ i + 1480 ] * wi + data[ i + 1481 ] * wr;
            uniform float tempr2 = data[ i + 1482 ] * wr2 - data[ i + 1483 ] * wi2;
            uniform float tempi2 = data[ i + 1482 ] * wi2 + data[ i + 1483 ] * wr2;
            data[ i + 1480 ] = data[ 1472 + i ] - tempr;
            data[ i + 1481 ] = data[ 1473 + i ] - tempi;
            data[ i + 1482 ] = data[ 1474 + i ] - tempr2;
            data[ i + 1483 ] = data[ 1475 + i ] - tempi2;
            data[ 1472 + i ] += tempr;
            data[ 1473 + i ] += tempi;
            data[ 1474 + i ] += tempr2;
            data[ 1475 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1488
    {
        uniform float tr = data[1490];
        uniform float ti = data[1491];
        data[1490] = data[1488] - tr;
        data[1491] = data[1489] - ti;
        data[1488] += tr;
        data[1489] += ti;
        tr = data[1494];
        ti = data[1495];
        data[1494] = data[1493] - ti;
        data[1495] = tr - data[1492];
        data[1492] += tr;
        data[1493] += ti;
        tr = data[1492];
        ti = data[1493];
        data[1492] = data[1488] - tr;
        data[1493] = data[1489] - ti;
        data[1488] += tr;
        data[1489] += ti;
        tr = data[1494];
        ti = data[1495];
        data[1494] = data[1490] - tr;
        data[1495] = data[1491] - ti;
        data[1490] += tr;
        data[1491] += ti;
    }
    // N = 4, at 1496
    {
        uniform float tr = data[1498];
        uniform float ti = data[1499];
        data[1498] = data[1496] - tr;
        data[1499] = data[1497] - ti;
        data[1496] += tr;
        data[1497] += ti;
        tr = data[1502];
        ti = data[1503];
        data[1502] = data[1501] - ti;
        data[1503] = tr - data[1500];
        data[1500] += tr;
        data[1501] += ti;
        tr = data[1500];
        ti = data[1501];
        data[1500] = data[1496] - tr;
        data[1501] = data[1497] - ti;
        data[1496] += tr;
        data[1497] += ti;
        tr = data[1502];
        ti = data[1503];
        data[1502] = data[1498] - tr;
        data[1503] = data[1499] - ti;
        data[1498] += tr;
        data[1499] += ti;
    }
    // N = 8, at 1488
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1496 ] * wr - data[ i + 1497 ] * wi;
            uniform float tempi  = data[ i + 1496 ] * wi + data[ i + 1497 ] * wr;
            uniform float tempr2 = data[ i + 1498 ] * wr2 - data[ i + 1499 ] * wi2;
            uniform float tempi2 = data[ i + 1498 ] * wi2 + data[ i + 1499 ] * wr2;
            data[ i + 1496 ] = data[ 1488 + i ] - tempr;
            data[ i + 1497 ] = data[ 1489 + i ] - tempi;
            data[ i + 1498 ] = data[ 1490 + i ] - tempr2;
            data[ i + 1499 ] = data[ 1491 + i ] - tempi2;
            data[ 1488 + i ] += tempr;
            data[ 1489 + i ] += tempi;
            data[ 1490 + i ] += tempr2;
            data[ 1491 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1472
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1488 ] * wr - data[ i + 1489 ] * wi;
            uniform float tempi  = data[ i + 1488 ] * wi + data[ i + 1489 ] * wr;
            uniform float tempr2 = data[ i + 1490 ] * wr2 - data[ i + 1491 ] * wi2;
            uniform float tempi2 = data[ i + 1490 ] * wi2 + data[ i + 1491 ] * wr2;
            data[ i + 1488 ] = data[ 1472 + i ] - tempr;
            data[ i + 1489 ] = data[ 1473 + i ] - tempi;
            data[ i + 1490 ] = data[ 1474 + i ] - tempr2;
            data[ i + 1491 ] = data[ 1475 + i ] - tempi2;
            data[ 1472 + i ] += tempr;
            data[ 1473 + i ] += tempi;
            data[ 1474 + i ] += tempr2;
            data[ 1475 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1504
    {
        uniform float tr = data[1506];
        uniform float ti = data[1507];
        data[1506] = data[1504] - tr;
        data[1507] = data[1505] - ti;
        data[1504] += tr;
        data[1505] += ti;
        tr = data[1510];
        ti = data[1511];
        data[1510] = data[1509] - ti;
        data[1511] = tr - data[1508];
        data[1508] += tr;
        data[1509] += ti;
        tr = data[1508];
        ti = data[1509];
        data[1508] = data[1504] - tr;
        data[1509] = data[1505] - ti;
        data[1504] += tr;
        data[1505] += ti;
        tr = data[1510];
        ti = data[1511];
        data[1510] = data[1506] - tr;
        data[1511] = data[1507] - ti;
        data[1506] += tr;
        data[1507] += ti;
    }
    // N = 4, at 1512
    {
        uniform float tr = data[1514];
        uniform float ti = data[1515];
        data[1514] = data[1512] - tr;
        data[1515] = data[1513] - ti;
        data[1512] += tr;
        data[1513] += ti;
        tr = data[1518];
        ti = data[1519];
        data[1518] = data[1517] - ti;
        data[1519] = tr - data[1516];
        data[1516] += tr;
        data[1517] += ti;
        tr = data[1516];
        ti = data[1517];
        data[1516] = data[1512] - tr;
        data[1517] = data[1513] - ti;
        data[1512] += tr;
        data[1513] += ti;
        tr = data[1518];
        ti = data[1519];
        data[1518] = data[1514] - tr;
        data[1519] = data[1515] - ti;
        data[1514] += tr;
        data[1515] += ti;
    }
    // N = 8, at 1504
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1512 ] * wr - data[ i + 1513 ] * wi;
            uniform float tempi  = data[ i + 1512 ] * wi + data[ i + 1513 ] * wr;
            uniform float tempr2 = data[ i + 1514 ] * wr2 - data[ i + 1515 ] * wi2;
            uniform float tempi2 = data[ i + 1514 ] * wi2 + data[ i + 1515 ] * wr2;
            data[ i + 1512 ] = data[ 1504 + i ] - tempr;
            data[ i + 1513 ] = data[ 1505 + i ] - tempi;
            data[ i + 1514 ] = data[ 1506 + i ] - tempr2;
            data[ i + 1515 ] = data[ 1507 + i ] - tempi2;
            data[ 1504 + i ] += tempr;
            data[ 1505 + i ] += tempi;
            data[ 1506 + i ] += tempr2;
            data[ 1507 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1520
    {
        uniform float tr = data[1522];
        uniform float ti = data[1523];
        data[1522] = data[1520] - tr;
        data[1523] = data[1521] - ti;
        data[1520] += tr;
        data[1521] += ti;
        tr = data[1526];
        ti = data[1527];
        data[1526] = data[1525] - ti;
        data[1527] = tr - data[1524];
        data[1524] += tr;
        data[1525] += ti;
        tr = data[1524];
        ti = data[1525];
        data[1524] = data[1520] - tr;
        data[1525] = data[1521] - ti;
        data[1520] += tr;
        data[1521] += ti;
        tr = data[1526];
        ti = data[1527];
        data[1526] = data[1522] - tr;
        data[1527] = data[1523] - ti;
        data[1522] += tr;
        data[1523] += ti;
    }
    // N = 4, at 1528
    {
        uniform float tr = data[1530];
        uniform float ti = data[1531];
        data[1530] = data[1528] - tr;
        data[1531] = data[1529] - ti;
        data[1528] += tr;
        data[1529] += ti;
        tr = data[1534];
        ti = data[1535];
        data[1534] = data[1533] - ti;
        data[1535] = tr - data[1532];
        data[1532] += tr;
        data[1533] += ti;
        tr = data[1532];
        ti = data[1533];
        data[1532] = data[1528] - tr;
        data[1533] = data[1529] - ti;
        data[1528] += tr;
        data[1529] += ti;
        tr = data[1534];
        ti = data[1535];
        data[1534] = data[1530] - tr;
        data[1535] = data[1531] - ti;
        data[1530] += tr;
        data[1531] += ti;
    }
    // N = 8, at 1520
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1528 ] * wr - data[ i + 1529 ] * wi;
            uniform float tempi  = data[ i + 1528 ] * wi + data[ i + 1529 ] * wr;
            uniform float tempr2 = data[ i + 1530 ] * wr2 - data[ i + 1531 ] * wi2;
            uniform float tempi2 = data[ i + 1530 ] * wi2 + data[ i + 1531 ] * wr2;
            data[ i + 1528 ] = data[ 1520 + i ] - tempr;
            data[ i + 1529 ] = data[ 1521 + i ] - tempi;
            data[ i + 1530 ] = data[ 1522 + i ] - tempr2;
            data[ i + 1531 ] = data[ 1523 + i ] - tempi2;
            data[ 1520 + i ] += tempr;
            data[ 1521 + i ] += tempi;
            data[ 1522 + i ] += tempr2;
            data[ 1523 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1504
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1520 ] * wr - data[ i + 1521 ] * wi;
            uniform float tempi  = data[ i + 1520 ] * wi + data[ i + 1521 ] * wr;
            uniform float tempr2 = data[ i + 1522 ] * wr2 - data[ i + 1523 ] * wi2;
            uniform float tempi2 = data[ i + 1522 ] * wi2 + data[ i + 1523 ] * wr2;
            data[ i + 1520 ] = data[ 1504 + i ] - tempr;
            data[ i + 1521 ] = data[ 1505 + i ] - tempi;
            data[ i + 1522 ] = data[ 1506 + i ] - tempr2;
            data[ i + 1523 ] = data[ 1507 + i ] - tempi2;
            data[ 1504 + i ] += tempr;
            data[ 1505 + i ] += tempi;
            data[ 1506 + i ] += tempr2;
            data[ 1507 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1472
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1504 ] * wr - data[ i + 1505 ] * wi;
            uniform float tempi  = data[ i + 1504 ] * wi + data[ i + 1505 ] * wr;
            uniform float tempr2 = data[ i + 1506 ] * wr2 - data[ i + 1507 ] * wi2;
            uniform float tempi2 = data[ i + 1506 ] * wi2 + data[ i + 1507 ] * wr2;
            data[ i + 1504 ] = data[ 1472 + i ] - tempr;
            data[ i + 1505 ] = data[ 1473 + i ] - tempi;
            data[ i + 1506 ] = data[ 1474 + i ] - tempr2;
            data[ i + 1507 ] = data[ 1475 + i ] - tempi2;
            data[ 1472 + i ] += tempr;
            data[ 1473 + i ] += tempi;
            data[ 1474 + i ] += tempr2;
            data[ 1475 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1408
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1472 ] * wr - data[ i + 1473 ] * wi;
            uniform float tempi  = data[ i + 1472 ] * wi + data[ i + 1473 ] * wr;
            uniform float tempr2 = data[ i + 1474 ] * wr2 - data[ i + 1475 ] * wi2;
            uniform float tempi2 = data[ i + 1474 ] * wi2 + data[ i + 1475 ] * wr2;
            data[ i + 1472 ] = data[ 1408 + i ] - tempr;
            data[ i + 1473 ] = data[ 1409 + i ] - tempi;
            data[ i + 1474 ] = data[ 1410 + i ] - tempr2;
            data[ i + 1475 ] = data[ 1411 + i ] - tempi2;
            data[ 1408 + i ] += tempr;
            data[ 1409 + i ] += tempi;
            data[ 1410 + i ] += tempr2;
            data[ 1411 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 1280
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1408 ] * wr - data[ i + 1409 ] * wi;
            uniform float tempi  = data[ i + 1408 ] * wi + data[ i + 1409 ] * wr;
            uniform float tempr2 = data[ i + 1410 ] * wr2 - data[ i + 1411 ] * wi2;
            uniform float tempi2 = data[ i + 1410 ] * wi2 + data[ i + 1411 ] * wr2;
            data[ i + 1408 ] = data[ 1280 + i ] - tempr;
            data[ i + 1409 ] = data[ 1281 + i ] - tempi;
            data[ i + 1410 ] = data[ 1282 + i ] - tempr2;
            data[ i + 1411 ] = data[ 1283 + i ] - tempi2;
            data[ 1280 + i ] += tempr;
            data[ 1281 + i ] += tempi;
            data[ 1282 + i ] += tempr2;
            data[ 1283 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 256, at 1024
    {
        uniform const_expr float sina = -0.012271538627185888531423f;
        uniform const_expr float sinb = -0.024541229205668591006884f;

        uniform const_expr float wpr = -0.000301181320557030655742f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 256; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1280 ] * wr - data[ i + 1281 ] * wi;
            uniform float tempi  = data[ i + 1280 ] * wi + data[ i + 1281 ] * wr;
            uniform float tempr2 = data[ i + 1282 ] * wr2 - data[ i + 1283 ] * wi2;
            uniform float tempi2 = data[ i + 1282 ] * wi2 + data[ i + 1283 ] * wr2;
            data[ i + 1280 ] = data[ 1024 + i ] - tempr;
            data[ i + 1281 ] = data[ 1025 + i ] - tempi;
            data[ i + 1282 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1283 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1536
    {
        uniform float tr = data[1538];
        uniform float ti = data[1539];
        data[1538] = data[1536] - tr;
        data[1539] = data[1537] - ti;
        data[1536] += tr;
        data[1537] += ti;
        tr = data[1542];
        ti = data[1543];
        data[1542] = data[1541] - ti;
        data[1543] = tr - data[1540];
        data[1540] += tr;
        data[1541] += ti;
        tr = data[1540];
        ti = data[1541];
        data[1540] = data[1536] - tr;
        data[1541] = data[1537] - ti;
        data[1536] += tr;
        data[1537] += ti;
        tr = data[1542];
        ti = data[1543];
        data[1542] = data[1538] - tr;
        data[1543] = data[1539] - ti;
        data[1538] += tr;
        data[1539] += ti;
    }
    // N = 4, at 1544
    {
        uniform float tr = data[1546];
        uniform float ti = data[1547];
        data[1546] = data[1544] - tr;
        data[1547] = data[1545] - ti;
        data[1544] += tr;
        data[1545] += ti;
        tr = data[1550];
        ti = data[1551];
        data[1550] = data[1549] - ti;
        data[1551] = tr - data[1548];
        data[1548] += tr;
        data[1549] += ti;
        tr = data[1548];
        ti = data[1549];
        data[1548] = data[1544] - tr;
        data[1549] = data[1545] - ti;
        data[1544] += tr;
        data[1545] += ti;
        tr = data[1550];
        ti = data[1551];
        data[1550] = data[1546] - tr;
        data[1551] = data[1547] - ti;
        data[1546] += tr;
        data[1547] += ti;
    }
    // N = 8, at 1536
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1544 ] * wr - data[ i + 1545 ] * wi;
            uniform float tempi  = data[ i + 1544 ] * wi + data[ i + 1545 ] * wr;
            uniform float tempr2 = data[ i + 1546 ] * wr2 - data[ i + 1547 ] * wi2;
            uniform float tempi2 = data[ i + 1546 ] * wi2 + data[ i + 1547 ] * wr2;
            data[ i + 1544 ] = data[ 1536 + i ] - tempr;
            data[ i + 1545 ] = data[ 1537 + i ] - tempi;
            data[ i + 1546 ] = data[ 1538 + i ] - tempr2;
            data[ i + 1547 ] = data[ 1539 + i ] - tempi2;
            data[ 1536 + i ] += tempr;
            data[ 1537 + i ] += tempi;
            data[ 1538 + i ] += tempr2;
            data[ 1539 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1552
    {
        uniform float tr = data[1554];
        uniform float ti = data[1555];
        data[1554] = data[1552] - tr;
        data[1555] = data[1553] - ti;
        data[1552] += tr;
        data[1553] += ti;
        tr = data[1558];
        ti = data[1559];
        data[1558] = data[1557] - ti;
        data[1559] = tr - data[1556];
        data[1556] += tr;
        data[1557] += ti;
        tr = data[1556];
        ti = data[1557];
        data[1556] = data[1552] - tr;
        data[1557] = data[1553] - ti;
        data[1552] += tr;
        data[1553] += ti;
        tr = data[1558];
        ti = data[1559];
        data[1558] = data[1554] - tr;
        data[1559] = data[1555] - ti;
        data[1554] += tr;
        data[1555] += ti;
    }
    // N = 4, at 1560
    {
        uniform float tr = data[1562];
        uniform float ti = data[1563];
        data[1562] = data[1560] - tr;
        data[1563] = data[1561] - ti;
        data[1560] += tr;
        data[1561] += ti;
        tr = data[1566];
        ti = data[1567];
        data[1566] = data[1565] - ti;
        data[1567] = tr - data[1564];
        data[1564] += tr;
        data[1565] += ti;
        tr = data[1564];
        ti = data[1565];
        data[1564] = data[1560] - tr;
        data[1565] = data[1561] - ti;
        data[1560] += tr;
        data[1561] += ti;
        tr = data[1566];
        ti = data[1567];
        data[1566] = data[1562] - tr;
        data[1567] = data[1563] - ti;
        data[1562] += tr;
        data[1563] += ti;
    }
    // N = 8, at 1552
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1560 ] * wr - data[ i + 1561 ] * wi;
            uniform float tempi  = data[ i + 1560 ] * wi + data[ i + 1561 ] * wr;
            uniform float tempr2 = data[ i + 1562 ] * wr2 - data[ i + 1563 ] * wi2;
            uniform float tempi2 = data[ i + 1562 ] * wi2 + data[ i + 1563 ] * wr2;
            data[ i + 1560 ] = data[ 1552 + i ] - tempr;
            data[ i + 1561 ] = data[ 1553 + i ] - tempi;
            data[ i + 1562 ] = data[ 1554 + i ] - tempr2;
            data[ i + 1563 ] = data[ 1555 + i ] - tempi2;
            data[ 1552 + i ] += tempr;
            data[ 1553 + i ] += tempi;
            data[ 1554 + i ] += tempr2;
            data[ 1555 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1536
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1552 ] * wr - data[ i + 1553 ] * wi;
            uniform float tempi  = data[ i + 1552 ] * wi + data[ i + 1553 ] * wr;
            uniform float tempr2 = data[ i + 1554 ] * wr2 - data[ i + 1555 ] * wi2;
            uniform float tempi2 = data[ i + 1554 ] * wi2 + data[ i + 1555 ] * wr2;
            data[ i + 1552 ] = data[ 1536 + i ] - tempr;
            data[ i + 1553 ] = data[ 1537 + i ] - tempi;
            data[ i + 1554 ] = data[ 1538 + i ] - tempr2;
            data[ i + 1555 ] = data[ 1539 + i ] - tempi2;
            data[ 1536 + i ] += tempr;
            data[ 1537 + i ] += tempi;
            data[ 1538 + i ] += tempr2;
            data[ 1539 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1568
    {
        uniform float tr = data[1570];
        uniform float ti = data[1571];
        data[1570] = data[1568] - tr;
        data[1571] = data[1569] - ti;
        data[1568] += tr;
        data[1569] += ti;
        tr = data[1574];
        ti = data[1575];
        data[1574] = data[1573] - ti;
        data[1575] = tr - data[1572];
        data[1572] += tr;
        data[1573] += ti;
        tr = data[1572];
        ti = data[1573];
        data[1572] = data[1568] - tr;
        data[1573] = data[1569] - ti;
        data[1568] += tr;
        data[1569] += ti;
        tr = data[1574];
        ti = data[1575];
        data[1574] = data[1570] - tr;
        data[1575] = data[1571] - ti;
        data[1570] += tr;
        data[1571] += ti;
    }
    // N = 4, at 1576
    {
        uniform float tr = data[1578];
        uniform float ti = data[1579];
        data[1578] = data[1576] - tr;
        data[1579] = data[1577] - ti;
        data[1576] += tr;
        data[1577] += ti;
        tr = data[1582];
        ti = data[1583];
        data[1582] = data[1581] - ti;
        data[1583] = tr - data[1580];
        data[1580] += tr;
        data[1581] += ti;
        tr = data[1580];
        ti = data[1581];
        data[1580] = data[1576] - tr;
        data[1581] = data[1577] - ti;
        data[1576] += tr;
        data[1577] += ti;
        tr = data[1582];
        ti = data[1583];
        data[1582] = data[1578] - tr;
        data[1583] = data[1579] - ti;
        data[1578] += tr;
        data[1579] += ti;
    }
    // N = 8, at 1568
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1576 ] * wr - data[ i + 1577 ] * wi;
            uniform float tempi  = data[ i + 1576 ] * wi + data[ i + 1577 ] * wr;
            uniform float tempr2 = data[ i + 1578 ] * wr2 - data[ i + 1579 ] * wi2;
            uniform float tempi2 = data[ i + 1578 ] * wi2 + data[ i + 1579 ] * wr2;
            data[ i + 1576 ] = data[ 1568 + i ] - tempr;
            data[ i + 1577 ] = data[ 1569 + i ] - tempi;
            data[ i + 1578 ] = data[ 1570 + i ] - tempr2;
            data[ i + 1579 ] = data[ 1571 + i ] - tempi2;
            data[ 1568 + i ] += tempr;
            data[ 1569 + i ] += tempi;
            data[ 1570 + i ] += tempr2;
            data[ 1571 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1584
    {
        uniform float tr = data[1586];
        uniform float ti = data[1587];
        data[1586] = data[1584] - tr;
        data[1587] = data[1585] - ti;
        data[1584] += tr;
        data[1585] += ti;
        tr = data[1590];
        ti = data[1591];
        data[1590] = data[1589] - ti;
        data[1591] = tr - data[1588];
        data[1588] += tr;
        data[1589] += ti;
        tr = data[1588];
        ti = data[1589];
        data[1588] = data[1584] - tr;
        data[1589] = data[1585] - ti;
        data[1584] += tr;
        data[1585] += ti;
        tr = data[1590];
        ti = data[1591];
        data[1590] = data[1586] - tr;
        data[1591] = data[1587] - ti;
        data[1586] += tr;
        data[1587] += ti;
    }
    // N = 4, at 1592
    {
        uniform float tr = data[1594];
        uniform float ti = data[1595];
        data[1594] = data[1592] - tr;
        data[1595] = data[1593] - ti;
        data[1592] += tr;
        data[1593] += ti;
        tr = data[1598];
        ti = data[1599];
        data[1598] = data[1597] - ti;
        data[1599] = tr - data[1596];
        data[1596] += tr;
        data[1597] += ti;
        tr = data[1596];
        ti = data[1597];
        data[1596] = data[1592] - tr;
        data[1597] = data[1593] - ti;
        data[1592] += tr;
        data[1593] += ti;
        tr = data[1598];
        ti = data[1599];
        data[1598] = data[1594] - tr;
        data[1599] = data[1595] - ti;
        data[1594] += tr;
        data[1595] += ti;
    }
    // N = 8, at 1584
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1592 ] * wr - data[ i + 1593 ] * wi;
            uniform float tempi  = data[ i + 1592 ] * wi + data[ i + 1593 ] * wr;
            uniform float tempr2 = data[ i + 1594 ] * wr2 - data[ i + 1595 ] * wi2;
            uniform float tempi2 = data[ i + 1594 ] * wi2 + data[ i + 1595 ] * wr2;
            data[ i + 1592 ] = data[ 1584 + i ] - tempr;
            data[ i + 1593 ] = data[ 1585 + i ] - tempi;
            data[ i + 1594 ] = data[ 1586 + i ] - tempr2;
            data[ i + 1595 ] = data[ 1587 + i ] - tempi2;
            data[ 1584 + i ] += tempr;
            data[ 1585 + i ] += tempi;
            data[ 1586 + i ] += tempr2;
            data[ 1587 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1568
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1584 ] * wr - data[ i + 1585 ] * wi;
            uniform float tempi  = data[ i + 1584 ] * wi + data[ i + 1585 ] * wr;
            uniform float tempr2 = data[ i + 1586 ] * wr2 - data[ i + 1587 ] * wi2;
            uniform float tempi2 = data[ i + 1586 ] * wi2 + data[ i + 1587 ] * wr2;
            data[ i + 1584 ] = data[ 1568 + i ] - tempr;
            data[ i + 1585 ] = data[ 1569 + i ] - tempi;
            data[ i + 1586 ] = data[ 1570 + i ] - tempr2;
            data[ i + 1587 ] = data[ 1571 + i ] - tempi2;
            data[ 1568 + i ] += tempr;
            data[ 1569 + i ] += tempi;
            data[ 1570 + i ] += tempr2;
            data[ 1571 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1536
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1568 ] * wr - data[ i + 1569 ] * wi;
            uniform float tempi  = data[ i + 1568 ] * wi + data[ i + 1569 ] * wr;
            uniform float tempr2 = data[ i + 1570 ] * wr2 - data[ i + 1571 ] * wi2;
            uniform float tempi2 = data[ i + 1570 ] * wi2 + data[ i + 1571 ] * wr2;
            data[ i + 1568 ] = data[ 1536 + i ] - tempr;
            data[ i + 1569 ] = data[ 1537 + i ] - tempi;
            data[ i + 1570 ] = data[ 1538 + i ] - tempr2;
            data[ i + 1571 ] = data[ 1539 + i ] - tempi2;
            data[ 1536 + i ] += tempr;
            data[ 1537 + i ] += tempi;
            data[ 1538 + i ] += tempr2;
            data[ 1539 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1600
    {
        uniform float tr = data[1602];
        uniform float ti = data[1603];
        data[1602] = data[1600] - tr;
        data[1603] = data[1601] - ti;
        data[1600] += tr;
        data[1601] += ti;
        tr = data[1606];
        ti = data[1607];
        data[1606] = data[1605] - ti;
        data[1607] = tr - data[1604];
        data[1604] += tr;
        data[1605] += ti;
        tr = data[1604];
        ti = data[1605];
        data[1604] = data[1600] - tr;
        data[1605] = data[1601] - ti;
        data[1600] += tr;
        data[1601] += ti;
        tr = data[1606];
        ti = data[1607];
        data[1606] = data[1602] - tr;
        data[1607] = data[1603] - ti;
        data[1602] += tr;
        data[1603] += ti;
    }
    // N = 4, at 1608
    {
        uniform float tr = data[1610];
        uniform float ti = data[1611];
        data[1610] = data[1608] - tr;
        data[1611] = data[1609] - ti;
        data[1608] += tr;
        data[1609] += ti;
        tr = data[1614];
        ti = data[1615];
        data[1614] = data[1613] - ti;
        data[1615] = tr - data[1612];
        data[1612] += tr;
        data[1613] += ti;
        tr = data[1612];
        ti = data[1613];
        data[1612] = data[1608] - tr;
        data[1613] = data[1609] - ti;
        data[1608] += tr;
        data[1609] += ti;
        tr = data[1614];
        ti = data[1615];
        data[1614] = data[1610] - tr;
        data[1615] = data[1611] - ti;
        data[1610] += tr;
        data[1611] += ti;
    }
    // N = 8, at 1600
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1608 ] * wr - data[ i + 1609 ] * wi;
            uniform float tempi  = data[ i + 1608 ] * wi + data[ i + 1609 ] * wr;
            uniform float tempr2 = data[ i + 1610 ] * wr2 - data[ i + 1611 ] * wi2;
            uniform float tempi2 = data[ i + 1610 ] * wi2 + data[ i + 1611 ] * wr2;
            data[ i + 1608 ] = data[ 1600 + i ] - tempr;
            data[ i + 1609 ] = data[ 1601 + i ] - tempi;
            data[ i + 1610 ] = data[ 1602 + i ] - tempr2;
            data[ i + 1611 ] = data[ 1603 + i ] - tempi2;
            data[ 1600 + i ] += tempr;
            data[ 1601 + i ] += tempi;
            data[ 1602 + i ] += tempr2;
            data[ 1603 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1616
    {
        uniform float tr = data[1618];
        uniform float ti = data[1619];
        data[1618] = data[1616] - tr;
        data[1619] = data[1617] - ti;
        data[1616] += tr;
        data[1617] += ti;
        tr = data[1622];
        ti = data[1623];
        data[1622] = data[1621] - ti;
        data[1623] = tr - data[1620];
        data[1620] += tr;
        data[1621] += ti;
        tr = data[1620];
        ti = data[1621];
        data[1620] = data[1616] - tr;
        data[1621] = data[1617] - ti;
        data[1616] += tr;
        data[1617] += ti;
        tr = data[1622];
        ti = data[1623];
        data[1622] = data[1618] - tr;
        data[1623] = data[1619] - ti;
        data[1618] += tr;
        data[1619] += ti;
    }
    // N = 4, at 1624
    {
        uniform float tr = data[1626];
        uniform float ti = data[1627];
        data[1626] = data[1624] - tr;
        data[1627] = data[1625] - ti;
        data[1624] += tr;
        data[1625] += ti;
        tr = data[1630];
        ti = data[1631];
        data[1630] = data[1629] - ti;
        data[1631] = tr - data[1628];
        data[1628] += tr;
        data[1629] += ti;
        tr = data[1628];
        ti = data[1629];
        data[1628] = data[1624] - tr;
        data[1629] = data[1625] - ti;
        data[1624] += tr;
        data[1625] += ti;
        tr = data[1630];
        ti = data[1631];
        data[1630] = data[1626] - tr;
        data[1631] = data[1627] - ti;
        data[1626] += tr;
        data[1627] += ti;
    }
    // N = 8, at 1616
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1624 ] * wr - data[ i + 1625 ] * wi;
            uniform float tempi  = data[ i + 1624 ] * wi + data[ i + 1625 ] * wr;
            uniform float tempr2 = data[ i + 1626 ] * wr2 - data[ i + 1627 ] * wi2;
            uniform float tempi2 = data[ i + 1626 ] * wi2 + data[ i + 1627 ] * wr2;
            data[ i + 1624 ] = data[ 1616 + i ] - tempr;
            data[ i + 1625 ] = data[ 1617 + i ] - tempi;
            data[ i + 1626 ] = data[ 1618 + i ] - tempr2;
            data[ i + 1627 ] = data[ 1619 + i ] - tempi2;
            data[ 1616 + i ] += tempr;
            data[ 1617 + i ] += tempi;
            data[ 1618 + i ] += tempr2;
            data[ 1619 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1600
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1616 ] * wr - data[ i + 1617 ] * wi;
            uniform float tempi  = data[ i + 1616 ] * wi + data[ i + 1617 ] * wr;
            uniform float tempr2 = data[ i + 1618 ] * wr2 - data[ i + 1619 ] * wi2;
            uniform float tempi2 = data[ i + 1618 ] * wi2 + data[ i + 1619 ] * wr2;
            data[ i + 1616 ] = data[ 1600 + i ] - tempr;
            data[ i + 1617 ] = data[ 1601 + i ] - tempi;
            data[ i + 1618 ] = data[ 1602 + i ] - tempr2;
            data[ i + 1619 ] = data[ 1603 + i ] - tempi2;
            data[ 1600 + i ] += tempr;
            data[ 1601 + i ] += tempi;
            data[ 1602 + i ] += tempr2;
            data[ 1603 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1632
    {
        uniform float tr = data[1634];
        uniform float ti = data[1635];
        data[1634] = data[1632] - tr;
        data[1635] = data[1633] - ti;
        data[1632] += tr;
        data[1633] += ti;
        tr = data[1638];
        ti = data[1639];
        data[1638] = data[1637] - ti;
        data[1639] = tr - data[1636];
        data[1636] += tr;
        data[1637] += ti;
        tr = data[1636];
        ti = data[1637];
        data[1636] = data[1632] - tr;
        data[1637] = data[1633] - ti;
        data[1632] += tr;
        data[1633] += ti;
        tr = data[1638];
        ti = data[1639];
        data[1638] = data[1634] - tr;
        data[1639] = data[1635] - ti;
        data[1634] += tr;
        data[1635] += ti;
    }
    // N = 4, at 1640
    {
        uniform float tr = data[1642];
        uniform float ti = data[1643];
        data[1642] = data[1640] - tr;
        data[1643] = data[1641] - ti;
        data[1640] += tr;
        data[1641] += ti;
        tr = data[1646];
        ti = data[1647];
        data[1646] = data[1645] - ti;
        data[1647] = tr - data[1644];
        data[1644] += tr;
        data[1645] += ti;
        tr = data[1644];
        ti = data[1645];
        data[1644] = data[1640] - tr;
        data[1645] = data[1641] - ti;
        data[1640] += tr;
        data[1641] += ti;
        tr = data[1646];
        ti = data[1647];
        data[1646] = data[1642] - tr;
        data[1647] = data[1643] - ti;
        data[1642] += tr;
        data[1643] += ti;
    }
    // N = 8, at 1632
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1640 ] * wr - data[ i + 1641 ] * wi;
            uniform float tempi  = data[ i + 1640 ] * wi + data[ i + 1641 ] * wr;
            uniform float tempr2 = data[ i + 1642 ] * wr2 - data[ i + 1643 ] * wi2;
            uniform float tempi2 = data[ i + 1642 ] * wi2 + data[ i + 1643 ] * wr2;
            data[ i + 1640 ] = data[ 1632 + i ] - tempr;
            data[ i + 1641 ] = data[ 1633 + i ] - tempi;
            data[ i + 1642 ] = data[ 1634 + i ] - tempr2;
            data[ i + 1643 ] = data[ 1635 + i ] - tempi2;
            data[ 1632 + i ] += tempr;
            data[ 1633 + i ] += tempi;
            data[ 1634 + i ] += tempr2;
            data[ 1635 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1648
    {
        uniform float tr = data[1650];
        uniform float ti = data[1651];
        data[1650] = data[1648] - tr;
        data[1651] = data[1649] - ti;
        data[1648] += tr;
        data[1649] += ti;
        tr = data[1654];
        ti = data[1655];
        data[1654] = data[1653] - ti;
        data[1655] = tr - data[1652];
        data[1652] += tr;
        data[1653] += ti;
        tr = data[1652];
        ti = data[1653];
        data[1652] = data[1648] - tr;
        data[1653] = data[1649] - ti;
        data[1648] += tr;
        data[1649] += ti;
        tr = data[1654];
        ti = data[1655];
        data[1654] = data[1650] - tr;
        data[1655] = data[1651] - ti;
        data[1650] += tr;
        data[1651] += ti;
    }
    // N = 4, at 1656
    {
        uniform float tr = data[1658];
        uniform float ti = data[1659];
        data[1658] = data[1656] - tr;
        data[1659] = data[1657] - ti;
        data[1656] += tr;
        data[1657] += ti;
        tr = data[1662];
        ti = data[1663];
        data[1662] = data[1661] - ti;
        data[1663] = tr - data[1660];
        data[1660] += tr;
        data[1661] += ti;
        tr = data[1660];
        ti = data[1661];
        data[1660] = data[1656] - tr;
        data[1661] = data[1657] - ti;
        data[1656] += tr;
        data[1657] += ti;
        tr = data[1662];
        ti = data[1663];
        data[1662] = data[1658] - tr;
        data[1663] = data[1659] - ti;
        data[1658] += tr;
        data[1659] += ti;
    }
    // N = 8, at 1648
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1656 ] * wr - data[ i + 1657 ] * wi;
            uniform float tempi  = data[ i + 1656 ] * wi + data[ i + 1657 ] * wr;
            uniform float tempr2 = data[ i + 1658 ] * wr2 - data[ i + 1659 ] * wi2;
            uniform float tempi2 = data[ i + 1658 ] * wi2 + data[ i + 1659 ] * wr2;
            data[ i + 1656 ] = data[ 1648 + i ] - tempr;
            data[ i + 1657 ] = data[ 1649 + i ] - tempi;
            data[ i + 1658 ] = data[ 1650 + i ] - tempr2;
            data[ i + 1659 ] = data[ 1651 + i ] - tempi2;
            data[ 1648 + i ] += tempr;
            data[ 1649 + i ] += tempi;
            data[ 1650 + i ] += tempr2;
            data[ 1651 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1632
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1648 ] * wr - data[ i + 1649 ] * wi;
            uniform float tempi  = data[ i + 1648 ] * wi + data[ i + 1649 ] * wr;
            uniform float tempr2 = data[ i + 1650 ] * wr2 - data[ i + 1651 ] * wi2;
            uniform float tempi2 = data[ i + 1650 ] * wi2 + data[ i + 1651 ] * wr2;
            data[ i + 1648 ] = data[ 1632 + i ] - tempr;
            data[ i + 1649 ] = data[ 1633 + i ] - tempi;
            data[ i + 1650 ] = data[ 1634 + i ] - tempr2;
            data[ i + 1651 ] = data[ 1635 + i ] - tempi2;
            data[ 1632 + i ] += tempr;
            data[ 1633 + i ] += tempi;
            data[ 1634 + i ] += tempr2;
            data[ 1635 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1600
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1632 ] * wr - data[ i + 1633 ] * wi;
            uniform float tempi  = data[ i + 1632 ] * wi + data[ i + 1633 ] * wr;
            uniform float tempr2 = data[ i + 1634 ] * wr2 - data[ i + 1635 ] * wi2;
            uniform float tempi2 = data[ i + 1634 ] * wi2 + data[ i + 1635 ] * wr2;
            data[ i + 1632 ] = data[ 1600 + i ] - tempr;
            data[ i + 1633 ] = data[ 1601 + i ] - tempi;
            data[ i + 1634 ] = data[ 1602 + i ] - tempr2;
            data[ i + 1635 ] = data[ 1603 + i ] - tempi2;
            data[ 1600 + i ] += tempr;
            data[ 1601 + i ] += tempi;
            data[ 1602 + i ] += tempr2;
            data[ 1603 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1536
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1600 ] * wr - data[ i + 1601 ] * wi;
            uniform float tempi  = data[ i + 1600 ] * wi + data[ i + 1601 ] * wr;
            uniform float tempr2 = data[ i + 1602 ] * wr2 - data[ i + 1603 ] * wi2;
            uniform float tempi2 = data[ i + 1602 ] * wi2 + data[ i + 1603 ] * wr2;
            data[ i + 1600 ] = data[ 1536 + i ] - tempr;
            data[ i + 1601 ] = data[ 1537 + i ] - tempi;
            data[ i + 1602 ] = data[ 1538 + i ] - tempr2;
            data[ i + 1603 ] = data[ 1539 + i ] - tempi2;
            data[ 1536 + i ] += tempr;
            data[ 1537 + i ] += tempi;
            data[ 1538 + i ] += tempr2;
            data[ 1539 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1664
    {
        uniform float tr = data[1666];
        uniform float ti = data[1667];
        data[1666] = data[1664] - tr;
        data[1667] = data[1665] - ti;
        data[1664] += tr;
        data[1665] += ti;
        tr = data[1670];
        ti = data[1671];
        data[1670] = data[1669] - ti;
        data[1671] = tr - data[1668];
        data[1668] += tr;
        data[1669] += ti;
        tr = data[1668];
        ti = data[1669];
        data[1668] = data[1664] - tr;
        data[1669] = data[1665] - ti;
        data[1664] += tr;
        data[1665] += ti;
        tr = data[1670];
        ti = data[1671];
        data[1670] = data[1666] - tr;
        data[1671] = data[1667] - ti;
        data[1666] += tr;
        data[1667] += ti;
    }
    // N = 4, at 1672
    {
        uniform float tr = data[1674];
        uniform float ti = data[1675];
        data[1674] = data[1672] - tr;
        data[1675] = data[1673] - ti;
        data[1672] += tr;
        data[1673] += ti;
        tr = data[1678];
        ti = data[1679];
        data[1678] = data[1677] - ti;
        data[1679] = tr - data[1676];
        data[1676] += tr;
        data[1677] += ti;
        tr = data[1676];
        ti = data[1677];
        data[1676] = data[1672] - tr;
        data[1677] = data[1673] - ti;
        data[1672] += tr;
        data[1673] += ti;
        tr = data[1678];
        ti = data[1679];
        data[1678] = data[1674] - tr;
        data[1679] = data[1675] - ti;
        data[1674] += tr;
        data[1675] += ti;
    }
    // N = 8, at 1664
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1672 ] * wr - data[ i + 1673 ] * wi;
            uniform float tempi  = data[ i + 1672 ] * wi + data[ i + 1673 ] * wr;
            uniform float tempr2 = data[ i + 1674 ] * wr2 - data[ i + 1675 ] * wi2;
            uniform float tempi2 = data[ i + 1674 ] * wi2 + data[ i + 1675 ] * wr2;
            data[ i + 1672 ] = data[ 1664 + i ] - tempr;
            data[ i + 1673 ] = data[ 1665 + i ] - tempi;
            data[ i + 1674 ] = data[ 1666 + i ] - tempr2;
            data[ i + 1675 ] = data[ 1667 + i ] - tempi2;
            data[ 1664 + i ] += tempr;
            data[ 1665 + i ] += tempi;
            data[ 1666 + i ] += tempr2;
            data[ 1667 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1680
    {
        uniform float tr = data[1682];
        uniform float ti = data[1683];
        data[1682] = data[1680] - tr;
        data[1683] = data[1681] - ti;
        data[1680] += tr;
        data[1681] += ti;
        tr = data[1686];
        ti = data[1687];
        data[1686] = data[1685] - ti;
        data[1687] = tr - data[1684];
        data[1684] += tr;
        data[1685] += ti;
        tr = data[1684];
        ti = data[1685];
        data[1684] = data[1680] - tr;
        data[1685] = data[1681] - ti;
        data[1680] += tr;
        data[1681] += ti;
        tr = data[1686];
        ti = data[1687];
        data[1686] = data[1682] - tr;
        data[1687] = data[1683] - ti;
        data[1682] += tr;
        data[1683] += ti;
    }
    // N = 4, at 1688
    {
        uniform float tr = data[1690];
        uniform float ti = data[1691];
        data[1690] = data[1688] - tr;
        data[1691] = data[1689] - ti;
        data[1688] += tr;
        data[1689] += ti;
        tr = data[1694];
        ti = data[1695];
        data[1694] = data[1693] - ti;
        data[1695] = tr - data[1692];
        data[1692] += tr;
        data[1693] += ti;
        tr = data[1692];
        ti = data[1693];
        data[1692] = data[1688] - tr;
        data[1693] = data[1689] - ti;
        data[1688] += tr;
        data[1689] += ti;
        tr = data[1694];
        ti = data[1695];
        data[1694] = data[1690] - tr;
        data[1695] = data[1691] - ti;
        data[1690] += tr;
        data[1691] += ti;
    }
    // N = 8, at 1680
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1688 ] * wr - data[ i + 1689 ] * wi;
            uniform float tempi  = data[ i + 1688 ] * wi + data[ i + 1689 ] * wr;
            uniform float tempr2 = data[ i + 1690 ] * wr2 - data[ i + 1691 ] * wi2;
            uniform float tempi2 = data[ i + 1690 ] * wi2 + data[ i + 1691 ] * wr2;
            data[ i + 1688 ] = data[ 1680 + i ] - tempr;
            data[ i + 1689 ] = data[ 1681 + i ] - tempi;
            data[ i + 1690 ] = data[ 1682 + i ] - tempr2;
            data[ i + 1691 ] = data[ 1683 + i ] - tempi2;
            data[ 1680 + i ] += tempr;
            data[ 1681 + i ] += tempi;
            data[ 1682 + i ] += tempr2;
            data[ 1683 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1664
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1680 ] * wr - data[ i + 1681 ] * wi;
            uniform float tempi  = data[ i + 1680 ] * wi + data[ i + 1681 ] * wr;
            uniform float tempr2 = data[ i + 1682 ] * wr2 - data[ i + 1683 ] * wi2;
            uniform float tempi2 = data[ i + 1682 ] * wi2 + data[ i + 1683 ] * wr2;
            data[ i + 1680 ] = data[ 1664 + i ] - tempr;
            data[ i + 1681 ] = data[ 1665 + i ] - tempi;
            data[ i + 1682 ] = data[ 1666 + i ] - tempr2;
            data[ i + 1683 ] = data[ 1667 + i ] - tempi2;
            data[ 1664 + i ] += tempr;
            data[ 1665 + i ] += tempi;
            data[ 1666 + i ] += tempr2;
            data[ 1667 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1696
    {
        uniform float tr = data[1698];
        uniform float ti = data[1699];
        data[1698] = data[1696] - tr;
        data[1699] = data[1697] - ti;
        data[1696] += tr;
        data[1697] += ti;
        tr = data[1702];
        ti = data[1703];
        data[1702] = data[1701] - ti;
        data[1703] = tr - data[1700];
        data[1700] += tr;
        data[1701] += ti;
        tr = data[1700];
        ti = data[1701];
        data[1700] = data[1696] - tr;
        data[1701] = data[1697] - ti;
        data[1696] += tr;
        data[1697] += ti;
        tr = data[1702];
        ti = data[1703];
        data[1702] = data[1698] - tr;
        data[1703] = data[1699] - ti;
        data[1698] += tr;
        data[1699] += ti;
    }
    // N = 4, at 1704
    {
        uniform float tr = data[1706];
        uniform float ti = data[1707];
        data[1706] = data[1704] - tr;
        data[1707] = data[1705] - ti;
        data[1704] += tr;
        data[1705] += ti;
        tr = data[1710];
        ti = data[1711];
        data[1710] = data[1709] - ti;
        data[1711] = tr - data[1708];
        data[1708] += tr;
        data[1709] += ti;
        tr = data[1708];
        ti = data[1709];
        data[1708] = data[1704] - tr;
        data[1709] = data[1705] - ti;
        data[1704] += tr;
        data[1705] += ti;
        tr = data[1710];
        ti = data[1711];
        data[1710] = data[1706] - tr;
        data[1711] = data[1707] - ti;
        data[1706] += tr;
        data[1707] += ti;
    }
    // N = 8, at 1696
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1704 ] * wr - data[ i + 1705 ] * wi;
            uniform float tempi  = data[ i + 1704 ] * wi + data[ i + 1705 ] * wr;
            uniform float tempr2 = data[ i + 1706 ] * wr2 - data[ i + 1707 ] * wi2;
            uniform float tempi2 = data[ i + 1706 ] * wi2 + data[ i + 1707 ] * wr2;
            data[ i + 1704 ] = data[ 1696 + i ] - tempr;
            data[ i + 1705 ] = data[ 1697 + i ] - tempi;
            data[ i + 1706 ] = data[ 1698 + i ] - tempr2;
            data[ i + 1707 ] = data[ 1699 + i ] - tempi2;
            data[ 1696 + i ] += tempr;
            data[ 1697 + i ] += tempi;
            data[ 1698 + i ] += tempr2;
            data[ 1699 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1712
    {
        uniform float tr = data[1714];
        uniform float ti = data[1715];
        data[1714] = data[1712] - tr;
        data[1715] = data[1713] - ti;
        data[1712] += tr;
        data[1713] += ti;
        tr = data[1718];
        ti = data[1719];
        data[1718] = data[1717] - ti;
        data[1719] = tr - data[1716];
        data[1716] += tr;
        data[1717] += ti;
        tr = data[1716];
        ti = data[1717];
        data[1716] = data[1712] - tr;
        data[1717] = data[1713] - ti;
        data[1712] += tr;
        data[1713] += ti;
        tr = data[1718];
        ti = data[1719];
        data[1718] = data[1714] - tr;
        data[1719] = data[1715] - ti;
        data[1714] += tr;
        data[1715] += ti;
    }
    // N = 4, at 1720
    {
        uniform float tr = data[1722];
        uniform float ti = data[1723];
        data[1722] = data[1720] - tr;
        data[1723] = data[1721] - ti;
        data[1720] += tr;
        data[1721] += ti;
        tr = data[1726];
        ti = data[1727];
        data[1726] = data[1725] - ti;
        data[1727] = tr - data[1724];
        data[1724] += tr;
        data[1725] += ti;
        tr = data[1724];
        ti = data[1725];
        data[1724] = data[1720] - tr;
        data[1725] = data[1721] - ti;
        data[1720] += tr;
        data[1721] += ti;
        tr = data[1726];
        ti = data[1727];
        data[1726] = data[1722] - tr;
        data[1727] = data[1723] - ti;
        data[1722] += tr;
        data[1723] += ti;
    }
    // N = 8, at 1712
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1720 ] * wr - data[ i + 1721 ] * wi;
            uniform float tempi  = data[ i + 1720 ] * wi + data[ i + 1721 ] * wr;
            uniform float tempr2 = data[ i + 1722 ] * wr2 - data[ i + 1723 ] * wi2;
            uniform float tempi2 = data[ i + 1722 ] * wi2 + data[ i + 1723 ] * wr2;
            data[ i + 1720 ] = data[ 1712 + i ] - tempr;
            data[ i + 1721 ] = data[ 1713 + i ] - tempi;
            data[ i + 1722 ] = data[ 1714 + i ] - tempr2;
            data[ i + 1723 ] = data[ 1715 + i ] - tempi2;
            data[ 1712 + i ] += tempr;
            data[ 1713 + i ] += tempi;
            data[ 1714 + i ] += tempr2;
            data[ 1715 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1696
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1712 ] * wr - data[ i + 1713 ] * wi;
            uniform float tempi  = data[ i + 1712 ] * wi + data[ i + 1713 ] * wr;
            uniform float tempr2 = data[ i + 1714 ] * wr2 - data[ i + 1715 ] * wi2;
            uniform float tempi2 = data[ i + 1714 ] * wi2 + data[ i + 1715 ] * wr2;
            data[ i + 1712 ] = data[ 1696 + i ] - tempr;
            data[ i + 1713 ] = data[ 1697 + i ] - tempi;
            data[ i + 1714 ] = data[ 1698 + i ] - tempr2;
            data[ i + 1715 ] = data[ 1699 + i ] - tempi2;
            data[ 1696 + i ] += tempr;
            data[ 1697 + i ] += tempi;
            data[ 1698 + i ] += tempr2;
            data[ 1699 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1664
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1696 ] * wr - data[ i + 1697 ] * wi;
            uniform float tempi  = data[ i + 1696 ] * wi + data[ i + 1697 ] * wr;
            uniform float tempr2 = data[ i + 1698 ] * wr2 - data[ i + 1699 ] * wi2;
            uniform float tempi2 = data[ i + 1698 ] * wi2 + data[ i + 1699 ] * wr2;
            data[ i + 1696 ] = data[ 1664 + i ] - tempr;
            data[ i + 1697 ] = data[ 1665 + i ] - tempi;
            data[ i + 1698 ] = data[ 1666 + i ] - tempr2;
            data[ i + 1699 ] = data[ 1667 + i ] - tempi2;
            data[ 1664 + i ] += tempr;
            data[ 1665 + i ] += tempi;
            data[ 1666 + i ] += tempr2;
            data[ 1667 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1728
    {
        uniform float tr = data[1730];
        uniform float ti = data[1731];
        data[1730] = data[1728] - tr;
        data[1731] = data[1729] - ti;
        data[1728] += tr;
        data[1729] += ti;
        tr = data[1734];
        ti = data[1735];
        data[1734] = data[1733] - ti;
        data[1735] = tr - data[1732];
        data[1732] += tr;
        data[1733] += ti;
        tr = data[1732];
        ti = data[1733];
        data[1732] = data[1728] - tr;
        data[1733] = data[1729] - ti;
        data[1728] += tr;
        data[1729] += ti;
        tr = data[1734];
        ti = data[1735];
        data[1734] = data[1730] - tr;
        data[1735] = data[1731] - ti;
        data[1730] += tr;
        data[1731] += ti;
    }
    // N = 4, at 1736
    {
        uniform float tr = data[1738];
        uniform float ti = data[1739];
        data[1738] = data[1736] - tr;
        data[1739] = data[1737] - ti;
        data[1736] += tr;
        data[1737] += ti;
        tr = data[1742];
        ti = data[1743];
        data[1742] = data[1741] - ti;
        data[1743] = tr - data[1740];
        data[1740] += tr;
        data[1741] += ti;
        tr = data[1740];
        ti = data[1741];
        data[1740] = data[1736] - tr;
        data[1741] = data[1737] - ti;
        data[1736] += tr;
        data[1737] += ti;
        tr = data[1742];
        ti = data[1743];
        data[1742] = data[1738] - tr;
        data[1743] = data[1739] - ti;
        data[1738] += tr;
        data[1739] += ti;
    }
    // N = 8, at 1728
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1736 ] * wr - data[ i + 1737 ] * wi;
            uniform float tempi  = data[ i + 1736 ] * wi + data[ i + 1737 ] * wr;
            uniform float tempr2 = data[ i + 1738 ] * wr2 - data[ i + 1739 ] * wi2;
            uniform float tempi2 = data[ i + 1738 ] * wi2 + data[ i + 1739 ] * wr2;
            data[ i + 1736 ] = data[ 1728 + i ] - tempr;
            data[ i + 1737 ] = data[ 1729 + i ] - tempi;
            data[ i + 1738 ] = data[ 1730 + i ] - tempr2;
            data[ i + 1739 ] = data[ 1731 + i ] - tempi2;
            data[ 1728 + i ] += tempr;
            data[ 1729 + i ] += tempi;
            data[ 1730 + i ] += tempr2;
            data[ 1731 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1744
    {
        uniform float tr = data[1746];
        uniform float ti = data[1747];
        data[1746] = data[1744] - tr;
        data[1747] = data[1745] - ti;
        data[1744] += tr;
        data[1745] += ti;
        tr = data[1750];
        ti = data[1751];
        data[1750] = data[1749] - ti;
        data[1751] = tr - data[1748];
        data[1748] += tr;
        data[1749] += ti;
        tr = data[1748];
        ti = data[1749];
        data[1748] = data[1744] - tr;
        data[1749] = data[1745] - ti;
        data[1744] += tr;
        data[1745] += ti;
        tr = data[1750];
        ti = data[1751];
        data[1750] = data[1746] - tr;
        data[1751] = data[1747] - ti;
        data[1746] += tr;
        data[1747] += ti;
    }
    // N = 4, at 1752
    {
        uniform float tr = data[1754];
        uniform float ti = data[1755];
        data[1754] = data[1752] - tr;
        data[1755] = data[1753] - ti;
        data[1752] += tr;
        data[1753] += ti;
        tr = data[1758];
        ti = data[1759];
        data[1758] = data[1757] - ti;
        data[1759] = tr - data[1756];
        data[1756] += tr;
        data[1757] += ti;
        tr = data[1756];
        ti = data[1757];
        data[1756] = data[1752] - tr;
        data[1757] = data[1753] - ti;
        data[1752] += tr;
        data[1753] += ti;
        tr = data[1758];
        ti = data[1759];
        data[1758] = data[1754] - tr;
        data[1759] = data[1755] - ti;
        data[1754] += tr;
        data[1755] += ti;
    }
    // N = 8, at 1744
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1752 ] * wr - data[ i + 1753 ] * wi;
            uniform float tempi  = data[ i + 1752 ] * wi + data[ i + 1753 ] * wr;
            uniform float tempr2 = data[ i + 1754 ] * wr2 - data[ i + 1755 ] * wi2;
            uniform float tempi2 = data[ i + 1754 ] * wi2 + data[ i + 1755 ] * wr2;
            data[ i + 1752 ] = data[ 1744 + i ] - tempr;
            data[ i + 1753 ] = data[ 1745 + i ] - tempi;
            data[ i + 1754 ] = data[ 1746 + i ] - tempr2;
            data[ i + 1755 ] = data[ 1747 + i ] - tempi2;
            data[ 1744 + i ] += tempr;
            data[ 1745 + i ] += tempi;
            data[ 1746 + i ] += tempr2;
            data[ 1747 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1728
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1744 ] * wr - data[ i + 1745 ] * wi;
            uniform float tempi  = data[ i + 1744 ] * wi + data[ i + 1745 ] * wr;
            uniform float tempr2 = data[ i + 1746 ] * wr2 - data[ i + 1747 ] * wi2;
            uniform float tempi2 = data[ i + 1746 ] * wi2 + data[ i + 1747 ] * wr2;
            data[ i + 1744 ] = data[ 1728 + i ] - tempr;
            data[ i + 1745 ] = data[ 1729 + i ] - tempi;
            data[ i + 1746 ] = data[ 1730 + i ] - tempr2;
            data[ i + 1747 ] = data[ 1731 + i ] - tempi2;
            data[ 1728 + i ] += tempr;
            data[ 1729 + i ] += tempi;
            data[ 1730 + i ] += tempr2;
            data[ 1731 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1760
    {
        uniform float tr = data[1762];
        uniform float ti = data[1763];
        data[1762] = data[1760] - tr;
        data[1763] = data[1761] - ti;
        data[1760] += tr;
        data[1761] += ti;
        tr = data[1766];
        ti = data[1767];
        data[1766] = data[1765] - ti;
        data[1767] = tr - data[1764];
        data[1764] += tr;
        data[1765] += ti;
        tr = data[1764];
        ti = data[1765];
        data[1764] = data[1760] - tr;
        data[1765] = data[1761] - ti;
        data[1760] += tr;
        data[1761] += ti;
        tr = data[1766];
        ti = data[1767];
        data[1766] = data[1762] - tr;
        data[1767] = data[1763] - ti;
        data[1762] += tr;
        data[1763] += ti;
    }
    // N = 4, at 1768
    {
        uniform float tr = data[1770];
        uniform float ti = data[1771];
        data[1770] = data[1768] - tr;
        data[1771] = data[1769] - ti;
        data[1768] += tr;
        data[1769] += ti;
        tr = data[1774];
        ti = data[1775];
        data[1774] = data[1773] - ti;
        data[1775] = tr - data[1772];
        data[1772] += tr;
        data[1773] += ti;
        tr = data[1772];
        ti = data[1773];
        data[1772] = data[1768] - tr;
        data[1773] = data[1769] - ti;
        data[1768] += tr;
        data[1769] += ti;
        tr = data[1774];
        ti = data[1775];
        data[1774] = data[1770] - tr;
        data[1775] = data[1771] - ti;
        data[1770] += tr;
        data[1771] += ti;
    }
    // N = 8, at 1760
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1768 ] * wr - data[ i + 1769 ] * wi;
            uniform float tempi  = data[ i + 1768 ] * wi + data[ i + 1769 ] * wr;
            uniform float tempr2 = data[ i + 1770 ] * wr2 - data[ i + 1771 ] * wi2;
            uniform float tempi2 = data[ i + 1770 ] * wi2 + data[ i + 1771 ] * wr2;
            data[ i + 1768 ] = data[ 1760 + i ] - tempr;
            data[ i + 1769 ] = data[ 1761 + i ] - tempi;
            data[ i + 1770 ] = data[ 1762 + i ] - tempr2;
            data[ i + 1771 ] = data[ 1763 + i ] - tempi2;
            data[ 1760 + i ] += tempr;
            data[ 1761 + i ] += tempi;
            data[ 1762 + i ] += tempr2;
            data[ 1763 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1776
    {
        uniform float tr = data[1778];
        uniform float ti = data[1779];
        data[1778] = data[1776] - tr;
        data[1779] = data[1777] - ti;
        data[1776] += tr;
        data[1777] += ti;
        tr = data[1782];
        ti = data[1783];
        data[1782] = data[1781] - ti;
        data[1783] = tr - data[1780];
        data[1780] += tr;
        data[1781] += ti;
        tr = data[1780];
        ti = data[1781];
        data[1780] = data[1776] - tr;
        data[1781] = data[1777] - ti;
        data[1776] += tr;
        data[1777] += ti;
        tr = data[1782];
        ti = data[1783];
        data[1782] = data[1778] - tr;
        data[1783] = data[1779] - ti;
        data[1778] += tr;
        data[1779] += ti;
    }
    // N = 4, at 1784
    {
        uniform float tr = data[1786];
        uniform float ti = data[1787];
        data[1786] = data[1784] - tr;
        data[1787] = data[1785] - ti;
        data[1784] += tr;
        data[1785] += ti;
        tr = data[1790];
        ti = data[1791];
        data[1790] = data[1789] - ti;
        data[1791] = tr - data[1788];
        data[1788] += tr;
        data[1789] += ti;
        tr = data[1788];
        ti = data[1789];
        data[1788] = data[1784] - tr;
        data[1789] = data[1785] - ti;
        data[1784] += tr;
        data[1785] += ti;
        tr = data[1790];
        ti = data[1791];
        data[1790] = data[1786] - tr;
        data[1791] = data[1787] - ti;
        data[1786] += tr;
        data[1787] += ti;
    }
    // N = 8, at 1776
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1784 ] * wr - data[ i + 1785 ] * wi;
            uniform float tempi  = data[ i + 1784 ] * wi + data[ i + 1785 ] * wr;
            uniform float tempr2 = data[ i + 1786 ] * wr2 - data[ i + 1787 ] * wi2;
            uniform float tempi2 = data[ i + 1786 ] * wi2 + data[ i + 1787 ] * wr2;
            data[ i + 1784 ] = data[ 1776 + i ] - tempr;
            data[ i + 1785 ] = data[ 1777 + i ] - tempi;
            data[ i + 1786 ] = data[ 1778 + i ] - tempr2;
            data[ i + 1787 ] = data[ 1779 + i ] - tempi2;
            data[ 1776 + i ] += tempr;
            data[ 1777 + i ] += tempi;
            data[ 1778 + i ] += tempr2;
            data[ 1779 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1760
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1776 ] * wr - data[ i + 1777 ] * wi;
            uniform float tempi  = data[ i + 1776 ] * wi + data[ i + 1777 ] * wr;
            uniform float tempr2 = data[ i + 1778 ] * wr2 - data[ i + 1779 ] * wi2;
            uniform float tempi2 = data[ i + 1778 ] * wi2 + data[ i + 1779 ] * wr2;
            data[ i + 1776 ] = data[ 1760 + i ] - tempr;
            data[ i + 1777 ] = data[ 1761 + i ] - tempi;
            data[ i + 1778 ] = data[ 1762 + i ] - tempr2;
            data[ i + 1779 ] = data[ 1763 + i ] - tempi2;
            data[ 1760 + i ] += tempr;
            data[ 1761 + i ] += tempi;
            data[ 1762 + i ] += tempr2;
            data[ 1763 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1728
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1760 ] * wr - data[ i + 1761 ] * wi;
            uniform float tempi  = data[ i + 1760 ] * wi + data[ i + 1761 ] * wr;
            uniform float tempr2 = data[ i + 1762 ] * wr2 - data[ i + 1763 ] * wi2;
            uniform float tempi2 = data[ i + 1762 ] * wi2 + data[ i + 1763 ] * wr2;
            data[ i + 1760 ] = data[ 1728 + i ] - tempr;
            data[ i + 1761 ] = data[ 1729 + i ] - tempi;
            data[ i + 1762 ] = data[ 1730 + i ] - tempr2;
            data[ i + 1763 ] = data[ 1731 + i ] - tempi2;
            data[ 1728 + i ] += tempr;
            data[ 1729 + i ] += tempi;
            data[ 1730 + i ] += tempr2;
            data[ 1731 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1664
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1728 ] * wr - data[ i + 1729 ] * wi;
            uniform float tempi  = data[ i + 1728 ] * wi + data[ i + 1729 ] * wr;
            uniform float tempr2 = data[ i + 1730 ] * wr2 - data[ i + 1731 ] * wi2;
            uniform float tempi2 = data[ i + 1730 ] * wi2 + data[ i + 1731 ] * wr2;
            data[ i + 1728 ] = data[ 1664 + i ] - tempr;
            data[ i + 1729 ] = data[ 1665 + i ] - tempi;
            data[ i + 1730 ] = data[ 1666 + i ] - tempr2;
            data[ i + 1731 ] = data[ 1667 + i ] - tempi2;
            data[ 1664 + i ] += tempr;
            data[ 1665 + i ] += tempi;
            data[ 1666 + i ] += tempr2;
            data[ 1667 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 1536
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1664 ] * wr - data[ i + 1665 ] * wi;
            uniform float tempi  = data[ i + 1664 ] * wi + data[ i + 1665 ] * wr;
            uniform float tempr2 = data[ i + 1666 ] * wr2 - data[ i + 1667 ] * wi2;
            uniform float tempi2 = data[ i + 1666 ] * wi2 + data[ i + 1667 ] * wr2;
            data[ i + 1664 ] = data[ 1536 + i ] - tempr;
            data[ i + 1665 ] = data[ 1537 + i ] - tempi;
            data[ i + 1666 ] = data[ 1538 + i ] - tempr2;
            data[ i + 1667 ] = data[ 1539 + i ] - tempi2;
            data[ 1536 + i ] += tempr;
            data[ 1537 + i ] += tempi;
            data[ 1538 + i ] += tempr2;
            data[ 1539 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1792
    {
        uniform float tr = data[1794];
        uniform float ti = data[1795];
        data[1794] = data[1792] - tr;
        data[1795] = data[1793] - ti;
        data[1792] += tr;
        data[1793] += ti;
        tr = data[1798];
        ti = data[1799];
        data[1798] = data[1797] - ti;
        data[1799] = tr - data[1796];
        data[1796] += tr;
        data[1797] += ti;
        tr = data[1796];
        ti = data[1797];
        data[1796] = data[1792] - tr;
        data[1797] = data[1793] - ti;
        data[1792] += tr;
        data[1793] += ti;
        tr = data[1798];
        ti = data[1799];
        data[1798] = data[1794] - tr;
        data[1799] = data[1795] - ti;
        data[1794] += tr;
        data[1795] += ti;
    }
    // N = 4, at 1800
    {
        uniform float tr = data[1802];
        uniform float ti = data[1803];
        data[1802] = data[1800] - tr;
        data[1803] = data[1801] - ti;
        data[1800] += tr;
        data[1801] += ti;
        tr = data[1806];
        ti = data[1807];
        data[1806] = data[1805] - ti;
        data[1807] = tr - data[1804];
        data[1804] += tr;
        data[1805] += ti;
        tr = data[1804];
        ti = data[1805];
        data[1804] = data[1800] - tr;
        data[1805] = data[1801] - ti;
        data[1800] += tr;
        data[1801] += ti;
        tr = data[1806];
        ti = data[1807];
        data[1806] = data[1802] - tr;
        data[1807] = data[1803] - ti;
        data[1802] += tr;
        data[1803] += ti;
    }
    // N = 8, at 1792
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1800 ] * wr - data[ i + 1801 ] * wi;
            uniform float tempi  = data[ i + 1800 ] * wi + data[ i + 1801 ] * wr;
            uniform float tempr2 = data[ i + 1802 ] * wr2 - data[ i + 1803 ] * wi2;
            uniform float tempi2 = data[ i + 1802 ] * wi2 + data[ i + 1803 ] * wr2;
            data[ i + 1800 ] = data[ 1792 + i ] - tempr;
            data[ i + 1801 ] = data[ 1793 + i ] - tempi;
            data[ i + 1802 ] = data[ 1794 + i ] - tempr2;
            data[ i + 1803 ] = data[ 1795 + i ] - tempi2;
            data[ 1792 + i ] += tempr;
            data[ 1793 + i ] += tempi;
            data[ 1794 + i ] += tempr2;
            data[ 1795 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1808
    {
        uniform float tr = data[1810];
        uniform float ti = data[1811];
        data[1810] = data[1808] - tr;
        data[1811] = data[1809] - ti;
        data[1808] += tr;
        data[1809] += ti;
        tr = data[1814];
        ti = data[1815];
        data[1814] = data[1813] - ti;
        data[1815] = tr - data[1812];
        data[1812] += tr;
        data[1813] += ti;
        tr = data[1812];
        ti = data[1813];
        data[1812] = data[1808] - tr;
        data[1813] = data[1809] - ti;
        data[1808] += tr;
        data[1809] += ti;
        tr = data[1814];
        ti = data[1815];
        data[1814] = data[1810] - tr;
        data[1815] = data[1811] - ti;
        data[1810] += tr;
        data[1811] += ti;
    }
    // N = 4, at 1816
    {
        uniform float tr = data[1818];
        uniform float ti = data[1819];
        data[1818] = data[1816] - tr;
        data[1819] = data[1817] - ti;
        data[1816] += tr;
        data[1817] += ti;
        tr = data[1822];
        ti = data[1823];
        data[1822] = data[1821] - ti;
        data[1823] = tr - data[1820];
        data[1820] += tr;
        data[1821] += ti;
        tr = data[1820];
        ti = data[1821];
        data[1820] = data[1816] - tr;
        data[1821] = data[1817] - ti;
        data[1816] += tr;
        data[1817] += ti;
        tr = data[1822];
        ti = data[1823];
        data[1822] = data[1818] - tr;
        data[1823] = data[1819] - ti;
        data[1818] += tr;
        data[1819] += ti;
    }
    // N = 8, at 1808
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1816 ] * wr - data[ i + 1817 ] * wi;
            uniform float tempi  = data[ i + 1816 ] * wi + data[ i + 1817 ] * wr;
            uniform float tempr2 = data[ i + 1818 ] * wr2 - data[ i + 1819 ] * wi2;
            uniform float tempi2 = data[ i + 1818 ] * wi2 + data[ i + 1819 ] * wr2;
            data[ i + 1816 ] = data[ 1808 + i ] - tempr;
            data[ i + 1817 ] = data[ 1809 + i ] - tempi;
            data[ i + 1818 ] = data[ 1810 + i ] - tempr2;
            data[ i + 1819 ] = data[ 1811 + i ] - tempi2;
            data[ 1808 + i ] += tempr;
            data[ 1809 + i ] += tempi;
            data[ 1810 + i ] += tempr2;
            data[ 1811 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1792
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1808 ] * wr - data[ i + 1809 ] * wi;
            uniform float tempi  = data[ i + 1808 ] * wi + data[ i + 1809 ] * wr;
            uniform float tempr2 = data[ i + 1810 ] * wr2 - data[ i + 1811 ] * wi2;
            uniform float tempi2 = data[ i + 1810 ] * wi2 + data[ i + 1811 ] * wr2;
            data[ i + 1808 ] = data[ 1792 + i ] - tempr;
            data[ i + 1809 ] = data[ 1793 + i ] - tempi;
            data[ i + 1810 ] = data[ 1794 + i ] - tempr2;
            data[ i + 1811 ] = data[ 1795 + i ] - tempi2;
            data[ 1792 + i ] += tempr;
            data[ 1793 + i ] += tempi;
            data[ 1794 + i ] += tempr2;
            data[ 1795 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1824
    {
        uniform float tr = data[1826];
        uniform float ti = data[1827];
        data[1826] = data[1824] - tr;
        data[1827] = data[1825] - ti;
        data[1824] += tr;
        data[1825] += ti;
        tr = data[1830];
        ti = data[1831];
        data[1830] = data[1829] - ti;
        data[1831] = tr - data[1828];
        data[1828] += tr;
        data[1829] += ti;
        tr = data[1828];
        ti = data[1829];
        data[1828] = data[1824] - tr;
        data[1829] = data[1825] - ti;
        data[1824] += tr;
        data[1825] += ti;
        tr = data[1830];
        ti = data[1831];
        data[1830] = data[1826] - tr;
        data[1831] = data[1827] - ti;
        data[1826] += tr;
        data[1827] += ti;
    }
    // N = 4, at 1832
    {
        uniform float tr = data[1834];
        uniform float ti = data[1835];
        data[1834] = data[1832] - tr;
        data[1835] = data[1833] - ti;
        data[1832] += tr;
        data[1833] += ti;
        tr = data[1838];
        ti = data[1839];
        data[1838] = data[1837] - ti;
        data[1839] = tr - data[1836];
        data[1836] += tr;
        data[1837] += ti;
        tr = data[1836];
        ti = data[1837];
        data[1836] = data[1832] - tr;
        data[1837] = data[1833] - ti;
        data[1832] += tr;
        data[1833] += ti;
        tr = data[1838];
        ti = data[1839];
        data[1838] = data[1834] - tr;
        data[1839] = data[1835] - ti;
        data[1834] += tr;
        data[1835] += ti;
    }
    // N = 8, at 1824
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1832 ] * wr - data[ i + 1833 ] * wi;
            uniform float tempi  = data[ i + 1832 ] * wi + data[ i + 1833 ] * wr;
            uniform float tempr2 = data[ i + 1834 ] * wr2 - data[ i + 1835 ] * wi2;
            uniform float tempi2 = data[ i + 1834 ] * wi2 + data[ i + 1835 ] * wr2;
            data[ i + 1832 ] = data[ 1824 + i ] - tempr;
            data[ i + 1833 ] = data[ 1825 + i ] - tempi;
            data[ i + 1834 ] = data[ 1826 + i ] - tempr2;
            data[ i + 1835 ] = data[ 1827 + i ] - tempi2;
            data[ 1824 + i ] += tempr;
            data[ 1825 + i ] += tempi;
            data[ 1826 + i ] += tempr2;
            data[ 1827 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1840
    {
        uniform float tr = data[1842];
        uniform float ti = data[1843];
        data[1842] = data[1840] - tr;
        data[1843] = data[1841] - ti;
        data[1840] += tr;
        data[1841] += ti;
        tr = data[1846];
        ti = data[1847];
        data[1846] = data[1845] - ti;
        data[1847] = tr - data[1844];
        data[1844] += tr;
        data[1845] += ti;
        tr = data[1844];
        ti = data[1845];
        data[1844] = data[1840] - tr;
        data[1845] = data[1841] - ti;
        data[1840] += tr;
        data[1841] += ti;
        tr = data[1846];
        ti = data[1847];
        data[1846] = data[1842] - tr;
        data[1847] = data[1843] - ti;
        data[1842] += tr;
        data[1843] += ti;
    }
    // N = 4, at 1848
    {
        uniform float tr = data[1850];
        uniform float ti = data[1851];
        data[1850] = data[1848] - tr;
        data[1851] = data[1849] - ti;
        data[1848] += tr;
        data[1849] += ti;
        tr = data[1854];
        ti = data[1855];
        data[1854] = data[1853] - ti;
        data[1855] = tr - data[1852];
        data[1852] += tr;
        data[1853] += ti;
        tr = data[1852];
        ti = data[1853];
        data[1852] = data[1848] - tr;
        data[1853] = data[1849] - ti;
        data[1848] += tr;
        data[1849] += ti;
        tr = data[1854];
        ti = data[1855];
        data[1854] = data[1850] - tr;
        data[1855] = data[1851] - ti;
        data[1850] += tr;
        data[1851] += ti;
    }
    // N = 8, at 1840
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1848 ] * wr - data[ i + 1849 ] * wi;
            uniform float tempi  = data[ i + 1848 ] * wi + data[ i + 1849 ] * wr;
            uniform float tempr2 = data[ i + 1850 ] * wr2 - data[ i + 1851 ] * wi2;
            uniform float tempi2 = data[ i + 1850 ] * wi2 + data[ i + 1851 ] * wr2;
            data[ i + 1848 ] = data[ 1840 + i ] - tempr;
            data[ i + 1849 ] = data[ 1841 + i ] - tempi;
            data[ i + 1850 ] = data[ 1842 + i ] - tempr2;
            data[ i + 1851 ] = data[ 1843 + i ] - tempi2;
            data[ 1840 + i ] += tempr;
            data[ 1841 + i ] += tempi;
            data[ 1842 + i ] += tempr2;
            data[ 1843 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1824
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1840 ] * wr - data[ i + 1841 ] * wi;
            uniform float tempi  = data[ i + 1840 ] * wi + data[ i + 1841 ] * wr;
            uniform float tempr2 = data[ i + 1842 ] * wr2 - data[ i + 1843 ] * wi2;
            uniform float tempi2 = data[ i + 1842 ] * wi2 + data[ i + 1843 ] * wr2;
            data[ i + 1840 ] = data[ 1824 + i ] - tempr;
            data[ i + 1841 ] = data[ 1825 + i ] - tempi;
            data[ i + 1842 ] = data[ 1826 + i ] - tempr2;
            data[ i + 1843 ] = data[ 1827 + i ] - tempi2;
            data[ 1824 + i ] += tempr;
            data[ 1825 + i ] += tempi;
            data[ 1826 + i ] += tempr2;
            data[ 1827 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1792
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1824 ] * wr - data[ i + 1825 ] * wi;
            uniform float tempi  = data[ i + 1824 ] * wi + data[ i + 1825 ] * wr;
            uniform float tempr2 = data[ i + 1826 ] * wr2 - data[ i + 1827 ] * wi2;
            uniform float tempi2 = data[ i + 1826 ] * wi2 + data[ i + 1827 ] * wr2;
            data[ i + 1824 ] = data[ 1792 + i ] - tempr;
            data[ i + 1825 ] = data[ 1793 + i ] - tempi;
            data[ i + 1826 ] = data[ 1794 + i ] - tempr2;
            data[ i + 1827 ] = data[ 1795 + i ] - tempi2;
            data[ 1792 + i ] += tempr;
            data[ 1793 + i ] += tempi;
            data[ 1794 + i ] += tempr2;
            data[ 1795 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1856
    {
        uniform float tr = data[1858];
        uniform float ti = data[1859];
        data[1858] = data[1856] - tr;
        data[1859] = data[1857] - ti;
        data[1856] += tr;
        data[1857] += ti;
        tr = data[1862];
        ti = data[1863];
        data[1862] = data[1861] - ti;
        data[1863] = tr - data[1860];
        data[1860] += tr;
        data[1861] += ti;
        tr = data[1860];
        ti = data[1861];
        data[1860] = data[1856] - tr;
        data[1861] = data[1857] - ti;
        data[1856] += tr;
        data[1857] += ti;
        tr = data[1862];
        ti = data[1863];
        data[1862] = data[1858] - tr;
        data[1863] = data[1859] - ti;
        data[1858] += tr;
        data[1859] += ti;
    }
    // N = 4, at 1864
    {
        uniform float tr = data[1866];
        uniform float ti = data[1867];
        data[1866] = data[1864] - tr;
        data[1867] = data[1865] - ti;
        data[1864] += tr;
        data[1865] += ti;
        tr = data[1870];
        ti = data[1871];
        data[1870] = data[1869] - ti;
        data[1871] = tr - data[1868];
        data[1868] += tr;
        data[1869] += ti;
        tr = data[1868];
        ti = data[1869];
        data[1868] = data[1864] - tr;
        data[1869] = data[1865] - ti;
        data[1864] += tr;
        data[1865] += ti;
        tr = data[1870];
        ti = data[1871];
        data[1870] = data[1866] - tr;
        data[1871] = data[1867] - ti;
        data[1866] += tr;
        data[1867] += ti;
    }
    // N = 8, at 1856
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1864 ] * wr - data[ i + 1865 ] * wi;
            uniform float tempi  = data[ i + 1864 ] * wi + data[ i + 1865 ] * wr;
            uniform float tempr2 = data[ i + 1866 ] * wr2 - data[ i + 1867 ] * wi2;
            uniform float tempi2 = data[ i + 1866 ] * wi2 + data[ i + 1867 ] * wr2;
            data[ i + 1864 ] = data[ 1856 + i ] - tempr;
            data[ i + 1865 ] = data[ 1857 + i ] - tempi;
            data[ i + 1866 ] = data[ 1858 + i ] - tempr2;
            data[ i + 1867 ] = data[ 1859 + i ] - tempi2;
            data[ 1856 + i ] += tempr;
            data[ 1857 + i ] += tempi;
            data[ 1858 + i ] += tempr2;
            data[ 1859 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1872
    {
        uniform float tr = data[1874];
        uniform float ti = data[1875];
        data[1874] = data[1872] - tr;
        data[1875] = data[1873] - ti;
        data[1872] += tr;
        data[1873] += ti;
        tr = data[1878];
        ti = data[1879];
        data[1878] = data[1877] - ti;
        data[1879] = tr - data[1876];
        data[1876] += tr;
        data[1877] += ti;
        tr = data[1876];
        ti = data[1877];
        data[1876] = data[1872] - tr;
        data[1877] = data[1873] - ti;
        data[1872] += tr;
        data[1873] += ti;
        tr = data[1878];
        ti = data[1879];
        data[1878] = data[1874] - tr;
        data[1879] = data[1875] - ti;
        data[1874] += tr;
        data[1875] += ti;
    }
    // N = 4, at 1880
    {
        uniform float tr = data[1882];
        uniform float ti = data[1883];
        data[1882] = data[1880] - tr;
        data[1883] = data[1881] - ti;
        data[1880] += tr;
        data[1881] += ti;
        tr = data[1886];
        ti = data[1887];
        data[1886] = data[1885] - ti;
        data[1887] = tr - data[1884];
        data[1884] += tr;
        data[1885] += ti;
        tr = data[1884];
        ti = data[1885];
        data[1884] = data[1880] - tr;
        data[1885] = data[1881] - ti;
        data[1880] += tr;
        data[1881] += ti;
        tr = data[1886];
        ti = data[1887];
        data[1886] = data[1882] - tr;
        data[1887] = data[1883] - ti;
        data[1882] += tr;
        data[1883] += ti;
    }
    // N = 8, at 1872
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1880 ] * wr - data[ i + 1881 ] * wi;
            uniform float tempi  = data[ i + 1880 ] * wi + data[ i + 1881 ] * wr;
            uniform float tempr2 = data[ i + 1882 ] * wr2 - data[ i + 1883 ] * wi2;
            uniform float tempi2 = data[ i + 1882 ] * wi2 + data[ i + 1883 ] * wr2;
            data[ i + 1880 ] = data[ 1872 + i ] - tempr;
            data[ i + 1881 ] = data[ 1873 + i ] - tempi;
            data[ i + 1882 ] = data[ 1874 + i ] - tempr2;
            data[ i + 1883 ] = data[ 1875 + i ] - tempi2;
            data[ 1872 + i ] += tempr;
            data[ 1873 + i ] += tempi;
            data[ 1874 + i ] += tempr2;
            data[ 1875 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1856
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1872 ] * wr - data[ i + 1873 ] * wi;
            uniform float tempi  = data[ i + 1872 ] * wi + data[ i + 1873 ] * wr;
            uniform float tempr2 = data[ i + 1874 ] * wr2 - data[ i + 1875 ] * wi2;
            uniform float tempi2 = data[ i + 1874 ] * wi2 + data[ i + 1875 ] * wr2;
            data[ i + 1872 ] = data[ 1856 + i ] - tempr;
            data[ i + 1873 ] = data[ 1857 + i ] - tempi;
            data[ i + 1874 ] = data[ 1858 + i ] - tempr2;
            data[ i + 1875 ] = data[ 1859 + i ] - tempi2;
            data[ 1856 + i ] += tempr;
            data[ 1857 + i ] += tempi;
            data[ 1858 + i ] += tempr2;
            data[ 1859 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1888
    {
        uniform float tr = data[1890];
        uniform float ti = data[1891];
        data[1890] = data[1888] - tr;
        data[1891] = data[1889] - ti;
        data[1888] += tr;
        data[1889] += ti;
        tr = data[1894];
        ti = data[1895];
        data[1894] = data[1893] - ti;
        data[1895] = tr - data[1892];
        data[1892] += tr;
        data[1893] += ti;
        tr = data[1892];
        ti = data[1893];
        data[1892] = data[1888] - tr;
        data[1893] = data[1889] - ti;
        data[1888] += tr;
        data[1889] += ti;
        tr = data[1894];
        ti = data[1895];
        data[1894] = data[1890] - tr;
        data[1895] = data[1891] - ti;
        data[1890] += tr;
        data[1891] += ti;
    }
    // N = 4, at 1896
    {
        uniform float tr = data[1898];
        uniform float ti = data[1899];
        data[1898] = data[1896] - tr;
        data[1899] = data[1897] - ti;
        data[1896] += tr;
        data[1897] += ti;
        tr = data[1902];
        ti = data[1903];
        data[1902] = data[1901] - ti;
        data[1903] = tr - data[1900];
        data[1900] += tr;
        data[1901] += ti;
        tr = data[1900];
        ti = data[1901];
        data[1900] = data[1896] - tr;
        data[1901] = data[1897] - ti;
        data[1896] += tr;
        data[1897] += ti;
        tr = data[1902];
        ti = data[1903];
        data[1902] = data[1898] - tr;
        data[1903] = data[1899] - ti;
        data[1898] += tr;
        data[1899] += ti;
    }
    // N = 8, at 1888
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1896 ] * wr - data[ i + 1897 ] * wi;
            uniform float tempi  = data[ i + 1896 ] * wi + data[ i + 1897 ] * wr;
            uniform float tempr2 = data[ i + 1898 ] * wr2 - data[ i + 1899 ] * wi2;
            uniform float tempi2 = data[ i + 1898 ] * wi2 + data[ i + 1899 ] * wr2;
            data[ i + 1896 ] = data[ 1888 + i ] - tempr;
            data[ i + 1897 ] = data[ 1889 + i ] - tempi;
            data[ i + 1898 ] = data[ 1890 + i ] - tempr2;
            data[ i + 1899 ] = data[ 1891 + i ] - tempi2;
            data[ 1888 + i ] += tempr;
            data[ 1889 + i ] += tempi;
            data[ 1890 + i ] += tempr2;
            data[ 1891 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1904
    {
        uniform float tr = data[1906];
        uniform float ti = data[1907];
        data[1906] = data[1904] - tr;
        data[1907] = data[1905] - ti;
        data[1904] += tr;
        data[1905] += ti;
        tr = data[1910];
        ti = data[1911];
        data[1910] = data[1909] - ti;
        data[1911] = tr - data[1908];
        data[1908] += tr;
        data[1909] += ti;
        tr = data[1908];
        ti = data[1909];
        data[1908] = data[1904] - tr;
        data[1909] = data[1905] - ti;
        data[1904] += tr;
        data[1905] += ti;
        tr = data[1910];
        ti = data[1911];
        data[1910] = data[1906] - tr;
        data[1911] = data[1907] - ti;
        data[1906] += tr;
        data[1907] += ti;
    }
    // N = 4, at 1912
    {
        uniform float tr = data[1914];
        uniform float ti = data[1915];
        data[1914] = data[1912] - tr;
        data[1915] = data[1913] - ti;
        data[1912] += tr;
        data[1913] += ti;
        tr = data[1918];
        ti = data[1919];
        data[1918] = data[1917] - ti;
        data[1919] = tr - data[1916];
        data[1916] += tr;
        data[1917] += ti;
        tr = data[1916];
        ti = data[1917];
        data[1916] = data[1912] - tr;
        data[1917] = data[1913] - ti;
        data[1912] += tr;
        data[1913] += ti;
        tr = data[1918];
        ti = data[1919];
        data[1918] = data[1914] - tr;
        data[1919] = data[1915] - ti;
        data[1914] += tr;
        data[1915] += ti;
    }
    // N = 8, at 1904
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1912 ] * wr - data[ i + 1913 ] * wi;
            uniform float tempi  = data[ i + 1912 ] * wi + data[ i + 1913 ] * wr;
            uniform float tempr2 = data[ i + 1914 ] * wr2 - data[ i + 1915 ] * wi2;
            uniform float tempi2 = data[ i + 1914 ] * wi2 + data[ i + 1915 ] * wr2;
            data[ i + 1912 ] = data[ 1904 + i ] - tempr;
            data[ i + 1913 ] = data[ 1905 + i ] - tempi;
            data[ i + 1914 ] = data[ 1906 + i ] - tempr2;
            data[ i + 1915 ] = data[ 1907 + i ] - tempi2;
            data[ 1904 + i ] += tempr;
            data[ 1905 + i ] += tempi;
            data[ 1906 + i ] += tempr2;
            data[ 1907 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1888
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1904 ] * wr - data[ i + 1905 ] * wi;
            uniform float tempi  = data[ i + 1904 ] * wi + data[ i + 1905 ] * wr;
            uniform float tempr2 = data[ i + 1906 ] * wr2 - data[ i + 1907 ] * wi2;
            uniform float tempi2 = data[ i + 1906 ] * wi2 + data[ i + 1907 ] * wr2;
            data[ i + 1904 ] = data[ 1888 + i ] - tempr;
            data[ i + 1905 ] = data[ 1889 + i ] - tempi;
            data[ i + 1906 ] = data[ 1890 + i ] - tempr2;
            data[ i + 1907 ] = data[ 1891 + i ] - tempi2;
            data[ 1888 + i ] += tempr;
            data[ 1889 + i ] += tempi;
            data[ 1890 + i ] += tempr2;
            data[ 1891 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1856
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1888 ] * wr - data[ i + 1889 ] * wi;
            uniform float tempi  = data[ i + 1888 ] * wi + data[ i + 1889 ] * wr;
            uniform float tempr2 = data[ i + 1890 ] * wr2 - data[ i + 1891 ] * wi2;
            uniform float tempi2 = data[ i + 1890 ] * wi2 + data[ i + 1891 ] * wr2;
            data[ i + 1888 ] = data[ 1856 + i ] - tempr;
            data[ i + 1889 ] = data[ 1857 + i ] - tempi;
            data[ i + 1890 ] = data[ 1858 + i ] - tempr2;
            data[ i + 1891 ] = data[ 1859 + i ] - tempi2;
            data[ 1856 + i ] += tempr;
            data[ 1857 + i ] += tempi;
            data[ 1858 + i ] += tempr2;
            data[ 1859 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1792
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1856 ] * wr - data[ i + 1857 ] * wi;
            uniform float tempi  = data[ i + 1856 ] * wi + data[ i + 1857 ] * wr;
            uniform float tempr2 = data[ i + 1858 ] * wr2 - data[ i + 1859 ] * wi2;
            uniform float tempi2 = data[ i + 1858 ] * wi2 + data[ i + 1859 ] * wr2;
            data[ i + 1856 ] = data[ 1792 + i ] - tempr;
            data[ i + 1857 ] = data[ 1793 + i ] - tempi;
            data[ i + 1858 ] = data[ 1794 + i ] - tempr2;
            data[ i + 1859 ] = data[ 1795 + i ] - tempi2;
            data[ 1792 + i ] += tempr;
            data[ 1793 + i ] += tempi;
            data[ 1794 + i ] += tempr2;
            data[ 1795 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1920
    {
        uniform float tr = data[1922];
        uniform float ti = data[1923];
        data[1922] = data[1920] - tr;
        data[1923] = data[1921] - ti;
        data[1920] += tr;
        data[1921] += ti;
        tr = data[1926];
        ti = data[1927];
        data[1926] = data[1925] - ti;
        data[1927] = tr - data[1924];
        data[1924] += tr;
        data[1925] += ti;
        tr = data[1924];
        ti = data[1925];
        data[1924] = data[1920] - tr;
        data[1925] = data[1921] - ti;
        data[1920] += tr;
        data[1921] += ti;
        tr = data[1926];
        ti = data[1927];
        data[1926] = data[1922] - tr;
        data[1927] = data[1923] - ti;
        data[1922] += tr;
        data[1923] += ti;
    }
    // N = 4, at 1928
    {
        uniform float tr = data[1930];
        uniform float ti = data[1931];
        data[1930] = data[1928] - tr;
        data[1931] = data[1929] - ti;
        data[1928] += tr;
        data[1929] += ti;
        tr = data[1934];
        ti = data[1935];
        data[1934] = data[1933] - ti;
        data[1935] = tr - data[1932];
        data[1932] += tr;
        data[1933] += ti;
        tr = data[1932];
        ti = data[1933];
        data[1932] = data[1928] - tr;
        data[1933] = data[1929] - ti;
        data[1928] += tr;
        data[1929] += ti;
        tr = data[1934];
        ti = data[1935];
        data[1934] = data[1930] - tr;
        data[1935] = data[1931] - ti;
        data[1930] += tr;
        data[1931] += ti;
    }
    // N = 8, at 1920
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1928 ] * wr - data[ i + 1929 ] * wi;
            uniform float tempi  = data[ i + 1928 ] * wi + data[ i + 1929 ] * wr;
            uniform float tempr2 = data[ i + 1930 ] * wr2 - data[ i + 1931 ] * wi2;
            uniform float tempi2 = data[ i + 1930 ] * wi2 + data[ i + 1931 ] * wr2;
            data[ i + 1928 ] = data[ 1920 + i ] - tempr;
            data[ i + 1929 ] = data[ 1921 + i ] - tempi;
            data[ i + 1930 ] = data[ 1922 + i ] - tempr2;
            data[ i + 1931 ] = data[ 1923 + i ] - tempi2;
            data[ 1920 + i ] += tempr;
            data[ 1921 + i ] += tempi;
            data[ 1922 + i ] += tempr2;
            data[ 1923 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1936
    {
        uniform float tr = data[1938];
        uniform float ti = data[1939];
        data[1938] = data[1936] - tr;
        data[1939] = data[1937] - ti;
        data[1936] += tr;
        data[1937] += ti;
        tr = data[1942];
        ti = data[1943];
        data[1942] = data[1941] - ti;
        data[1943] = tr - data[1940];
        data[1940] += tr;
        data[1941] += ti;
        tr = data[1940];
        ti = data[1941];
        data[1940] = data[1936] - tr;
        data[1941] = data[1937] - ti;
        data[1936] += tr;
        data[1937] += ti;
        tr = data[1942];
        ti = data[1943];
        data[1942] = data[1938] - tr;
        data[1943] = data[1939] - ti;
        data[1938] += tr;
        data[1939] += ti;
    }
    // N = 4, at 1944
    {
        uniform float tr = data[1946];
        uniform float ti = data[1947];
        data[1946] = data[1944] - tr;
        data[1947] = data[1945] - ti;
        data[1944] += tr;
        data[1945] += ti;
        tr = data[1950];
        ti = data[1951];
        data[1950] = data[1949] - ti;
        data[1951] = tr - data[1948];
        data[1948] += tr;
        data[1949] += ti;
        tr = data[1948];
        ti = data[1949];
        data[1948] = data[1944] - tr;
        data[1949] = data[1945] - ti;
        data[1944] += tr;
        data[1945] += ti;
        tr = data[1950];
        ti = data[1951];
        data[1950] = data[1946] - tr;
        data[1951] = data[1947] - ti;
        data[1946] += tr;
        data[1947] += ti;
    }
    // N = 8, at 1936
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1944 ] * wr - data[ i + 1945 ] * wi;
            uniform float tempi  = data[ i + 1944 ] * wi + data[ i + 1945 ] * wr;
            uniform float tempr2 = data[ i + 1946 ] * wr2 - data[ i + 1947 ] * wi2;
            uniform float tempi2 = data[ i + 1946 ] * wi2 + data[ i + 1947 ] * wr2;
            data[ i + 1944 ] = data[ 1936 + i ] - tempr;
            data[ i + 1945 ] = data[ 1937 + i ] - tempi;
            data[ i + 1946 ] = data[ 1938 + i ] - tempr2;
            data[ i + 1947 ] = data[ 1939 + i ] - tempi2;
            data[ 1936 + i ] += tempr;
            data[ 1937 + i ] += tempi;
            data[ 1938 + i ] += tempr2;
            data[ 1939 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1920
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1936 ] * wr - data[ i + 1937 ] * wi;
            uniform float tempi  = data[ i + 1936 ] * wi + data[ i + 1937 ] * wr;
            uniform float tempr2 = data[ i + 1938 ] * wr2 - data[ i + 1939 ] * wi2;
            uniform float tempi2 = data[ i + 1938 ] * wi2 + data[ i + 1939 ] * wr2;
            data[ i + 1936 ] = data[ 1920 + i ] - tempr;
            data[ i + 1937 ] = data[ 1921 + i ] - tempi;
            data[ i + 1938 ] = data[ 1922 + i ] - tempr2;
            data[ i + 1939 ] = data[ 1923 + i ] - tempi2;
            data[ 1920 + i ] += tempr;
            data[ 1921 + i ] += tempi;
            data[ 1922 + i ] += tempr2;
            data[ 1923 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1952
    {
        uniform float tr = data[1954];
        uniform float ti = data[1955];
        data[1954] = data[1952] - tr;
        data[1955] = data[1953] - ti;
        data[1952] += tr;
        data[1953] += ti;
        tr = data[1958];
        ti = data[1959];
        data[1958] = data[1957] - ti;
        data[1959] = tr - data[1956];
        data[1956] += tr;
        data[1957] += ti;
        tr = data[1956];
        ti = data[1957];
        data[1956] = data[1952] - tr;
        data[1957] = data[1953] - ti;
        data[1952] += tr;
        data[1953] += ti;
        tr = data[1958];
        ti = data[1959];
        data[1958] = data[1954] - tr;
        data[1959] = data[1955] - ti;
        data[1954] += tr;
        data[1955] += ti;
    }
    // N = 4, at 1960
    {
        uniform float tr = data[1962];
        uniform float ti = data[1963];
        data[1962] = data[1960] - tr;
        data[1963] = data[1961] - ti;
        data[1960] += tr;
        data[1961] += ti;
        tr = data[1966];
        ti = data[1967];
        data[1966] = data[1965] - ti;
        data[1967] = tr - data[1964];
        data[1964] += tr;
        data[1965] += ti;
        tr = data[1964];
        ti = data[1965];
        data[1964] = data[1960] - tr;
        data[1965] = data[1961] - ti;
        data[1960] += tr;
        data[1961] += ti;
        tr = data[1966];
        ti = data[1967];
        data[1966] = data[1962] - tr;
        data[1967] = data[1963] - ti;
        data[1962] += tr;
        data[1963] += ti;
    }
    // N = 8, at 1952
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1960 ] * wr - data[ i + 1961 ] * wi;
            uniform float tempi  = data[ i + 1960 ] * wi + data[ i + 1961 ] * wr;
            uniform float tempr2 = data[ i + 1962 ] * wr2 - data[ i + 1963 ] * wi2;
            uniform float tempi2 = data[ i + 1962 ] * wi2 + data[ i + 1963 ] * wr2;
            data[ i + 1960 ] = data[ 1952 + i ] - tempr;
            data[ i + 1961 ] = data[ 1953 + i ] - tempi;
            data[ i + 1962 ] = data[ 1954 + i ] - tempr2;
            data[ i + 1963 ] = data[ 1955 + i ] - tempi2;
            data[ 1952 + i ] += tempr;
            data[ 1953 + i ] += tempi;
            data[ 1954 + i ] += tempr2;
            data[ 1955 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1968
    {
        uniform float tr = data[1970];
        uniform float ti = data[1971];
        data[1970] = data[1968] - tr;
        data[1971] = data[1969] - ti;
        data[1968] += tr;
        data[1969] += ti;
        tr = data[1974];
        ti = data[1975];
        data[1974] = data[1973] - ti;
        data[1975] = tr - data[1972];
        data[1972] += tr;
        data[1973] += ti;
        tr = data[1972];
        ti = data[1973];
        data[1972] = data[1968] - tr;
        data[1973] = data[1969] - ti;
        data[1968] += tr;
        data[1969] += ti;
        tr = data[1974];
        ti = data[1975];
        data[1974] = data[1970] - tr;
        data[1975] = data[1971] - ti;
        data[1970] += tr;
        data[1971] += ti;
    }
    // N = 4, at 1976
    {
        uniform float tr = data[1978];
        uniform float ti = data[1979];
        data[1978] = data[1976] - tr;
        data[1979] = data[1977] - ti;
        data[1976] += tr;
        data[1977] += ti;
        tr = data[1982];
        ti = data[1983];
        data[1982] = data[1981] - ti;
        data[1983] = tr - data[1980];
        data[1980] += tr;
        data[1981] += ti;
        tr = data[1980];
        ti = data[1981];
        data[1980] = data[1976] - tr;
        data[1981] = data[1977] - ti;
        data[1976] += tr;
        data[1977] += ti;
        tr = data[1982];
        ti = data[1983];
        data[1982] = data[1978] - tr;
        data[1983] = data[1979] - ti;
        data[1978] += tr;
        data[1979] += ti;
    }
    // N = 8, at 1968
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1976 ] * wr - data[ i + 1977 ] * wi;
            uniform float tempi  = data[ i + 1976 ] * wi + data[ i + 1977 ] * wr;
            uniform float tempr2 = data[ i + 1978 ] * wr2 - data[ i + 1979 ] * wi2;
            uniform float tempi2 = data[ i + 1978 ] * wi2 + data[ i + 1979 ] * wr2;
            data[ i + 1976 ] = data[ 1968 + i ] - tempr;
            data[ i + 1977 ] = data[ 1969 + i ] - tempi;
            data[ i + 1978 ] = data[ 1970 + i ] - tempr2;
            data[ i + 1979 ] = data[ 1971 + i ] - tempi2;
            data[ 1968 + i ] += tempr;
            data[ 1969 + i ] += tempi;
            data[ 1970 + i ] += tempr2;
            data[ 1971 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1952
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1968 ] * wr - data[ i + 1969 ] * wi;
            uniform float tempi  = data[ i + 1968 ] * wi + data[ i + 1969 ] * wr;
            uniform float tempr2 = data[ i + 1970 ] * wr2 - data[ i + 1971 ] * wi2;
            uniform float tempi2 = data[ i + 1970 ] * wi2 + data[ i + 1971 ] * wr2;
            data[ i + 1968 ] = data[ 1952 + i ] - tempr;
            data[ i + 1969 ] = data[ 1953 + i ] - tempi;
            data[ i + 1970 ] = data[ 1954 + i ] - tempr2;
            data[ i + 1971 ] = data[ 1955 + i ] - tempi2;
            data[ 1952 + i ] += tempr;
            data[ 1953 + i ] += tempi;
            data[ 1954 + i ] += tempr2;
            data[ 1955 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1920
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1952 ] * wr - data[ i + 1953 ] * wi;
            uniform float tempi  = data[ i + 1952 ] * wi + data[ i + 1953 ] * wr;
            uniform float tempr2 = data[ i + 1954 ] * wr2 - data[ i + 1955 ] * wi2;
            uniform float tempi2 = data[ i + 1954 ] * wi2 + data[ i + 1955 ] * wr2;
            data[ i + 1952 ] = data[ 1920 + i ] - tempr;
            data[ i + 1953 ] = data[ 1921 + i ] - tempi;
            data[ i + 1954 ] = data[ 1922 + i ] - tempr2;
            data[ i + 1955 ] = data[ 1923 + i ] - tempi2;
            data[ 1920 + i ] += tempr;
            data[ 1921 + i ] += tempi;
            data[ 1922 + i ] += tempr2;
            data[ 1923 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 1984
    {
        uniform float tr = data[1986];
        uniform float ti = data[1987];
        data[1986] = data[1984] - tr;
        data[1987] = data[1985] - ti;
        data[1984] += tr;
        data[1985] += ti;
        tr = data[1990];
        ti = data[1991];
        data[1990] = data[1989] - ti;
        data[1991] = tr - data[1988];
        data[1988] += tr;
        data[1989] += ti;
        tr = data[1988];
        ti = data[1989];
        data[1988] = data[1984] - tr;
        data[1989] = data[1985] - ti;
        data[1984] += tr;
        data[1985] += ti;
        tr = data[1990];
        ti = data[1991];
        data[1990] = data[1986] - tr;
        data[1991] = data[1987] - ti;
        data[1986] += tr;
        data[1987] += ti;
    }
    // N = 4, at 1992
    {
        uniform float tr = data[1994];
        uniform float ti = data[1995];
        data[1994] = data[1992] - tr;
        data[1995] = data[1993] - ti;
        data[1992] += tr;
        data[1993] += ti;
        tr = data[1998];
        ti = data[1999];
        data[1998] = data[1997] - ti;
        data[1999] = tr - data[1996];
        data[1996] += tr;
        data[1997] += ti;
        tr = data[1996];
        ti = data[1997];
        data[1996] = data[1992] - tr;
        data[1997] = data[1993] - ti;
        data[1992] += tr;
        data[1993] += ti;
        tr = data[1998];
        ti = data[1999];
        data[1998] = data[1994] - tr;
        data[1999] = data[1995] - ti;
        data[1994] += tr;
        data[1995] += ti;
    }
    // N = 8, at 1984
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1992 ] * wr - data[ i + 1993 ] * wi;
            uniform float tempi  = data[ i + 1992 ] * wi + data[ i + 1993 ] * wr;
            uniform float tempr2 = data[ i + 1994 ] * wr2 - data[ i + 1995 ] * wi2;
            uniform float tempi2 = data[ i + 1994 ] * wi2 + data[ i + 1995 ] * wr2;
            data[ i + 1992 ] = data[ 1984 + i ] - tempr;
            data[ i + 1993 ] = data[ 1985 + i ] - tempi;
            data[ i + 1994 ] = data[ 1986 + i ] - tempr2;
            data[ i + 1995 ] = data[ 1987 + i ] - tempi2;
            data[ 1984 + i ] += tempr;
            data[ 1985 + i ] += tempi;
            data[ 1986 + i ] += tempr2;
            data[ 1987 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 2000
    {
        uniform float tr = data[2002];
        uniform float ti = data[2003];
        data[2002] = data[2000] - tr;
        data[2003] = data[2001] - ti;
        data[2000] += tr;
        data[2001] += ti;
        tr = data[2006];
        ti = data[2007];
        data[2006] = data[2005] - ti;
        data[2007] = tr - data[2004];
        data[2004] += tr;
        data[2005] += ti;
        tr = data[2004];
        ti = data[2005];
        data[2004] = data[2000] - tr;
        data[2005] = data[2001] - ti;
        data[2000] += tr;
        data[2001] += ti;
        tr = data[2006];
        ti = data[2007];
        data[2006] = data[2002] - tr;
        data[2007] = data[2003] - ti;
        data[2002] += tr;
        data[2003] += ti;
    }
    // N = 4, at 2008
    {
        uniform float tr = data[2010];
        uniform float ti = data[2011];
        data[2010] = data[2008] - tr;
        data[2011] = data[2009] - ti;
        data[2008] += tr;
        data[2009] += ti;
        tr = data[2014];
        ti = data[2015];
        data[2014] = data[2013] - ti;
        data[2015] = tr - data[2012];
        data[2012] += tr;
        data[2013] += ti;
        tr = data[2012];
        ti = data[2013];
        data[2012] = data[2008] - tr;
        data[2013] = data[2009] - ti;
        data[2008] += tr;
        data[2009] += ti;
        tr = data[2014];
        ti = data[2015];
        data[2014] = data[2010] - tr;
        data[2015] = data[2011] - ti;
        data[2010] += tr;
        data[2011] += ti;
    }
    // N = 8, at 2000
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 2008 ] * wr - data[ i + 2009 ] * wi;
            uniform float tempi  = data[ i + 2008 ] * wi + data[ i + 2009 ] * wr;
            uniform float tempr2 = data[ i + 2010 ] * wr2 - data[ i + 2011 ] * wi2;
            uniform float tempi2 = data[ i + 2010 ] * wi2 + data[ i + 2011 ] * wr2;
            data[ i + 2008 ] = data[ 2000 + i ] - tempr;
            data[ i + 2009 ] = data[ 2001 + i ] - tempi;
            data[ i + 2010 ] = data[ 2002 + i ] - tempr2;
            data[ i + 2011 ] = data[ 2003 + i ] - tempi2;
            data[ 2000 + i ] += tempr;
            data[ 2001 + i ] += tempi;
            data[ 2002 + i ] += tempr2;
            data[ 2003 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 1984
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 2000 ] * wr - data[ i + 2001 ] * wi;
            uniform float tempi  = data[ i + 2000 ] * wi + data[ i + 2001 ] * wr;
            uniform float tempr2 = data[ i + 2002 ] * wr2 - data[ i + 2003 ] * wi2;
            uniform float tempi2 = data[ i + 2002 ] * wi2 + data[ i + 2003 ] * wr2;
            data[ i + 2000 ] = data[ 1984 + i ] - tempr;
            data[ i + 2001 ] = data[ 1985 + i ] - tempi;
            data[ i + 2002 ] = data[ 1986 + i ] - tempr2;
            data[ i + 2003 ] = data[ 1987 + i ] - tempi2;
            data[ 1984 + i ] += tempr;
            data[ 1985 + i ] += tempi;
            data[ 1986 + i ] += tempr2;
            data[ 1987 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 2016
    {
        uniform float tr = data[2018];
        uniform float ti = data[2019];
        data[2018] = data[2016] - tr;
        data[2019] = data[2017] - ti;
        data[2016] += tr;
        data[2017] += ti;
        tr = data[2022];
        ti = data[2023];
        data[2022] = data[2021] - ti;
        data[2023] = tr - data[2020];
        data[2020] += tr;
        data[2021] += ti;
        tr = data[2020];
        ti = data[2021];
        data[2020] = data[2016] - tr;
        data[2021] = data[2017] - ti;
        data[2016] += tr;
        data[2017] += ti;
        tr = data[2022];
        ti = data[2023];
        data[2022] = data[2018] - tr;
        data[2023] = data[2019] - ti;
        data[2018] += tr;
        data[2019] += ti;
    }
    // N = 4, at 2024
    {
        uniform float tr = data[2026];
        uniform float ti = data[2027];
        data[2026] = data[2024] - tr;
        data[2027] = data[2025] - ti;
        data[2024] += tr;
        data[2025] += ti;
        tr = data[2030];
        ti = data[2031];
        data[2030] = data[2029] - ti;
        data[2031] = tr - data[2028];
        data[2028] += tr;
        data[2029] += ti;
        tr = data[2028];
        ti = data[2029];
        data[2028] = data[2024] - tr;
        data[2029] = data[2025] - ti;
        data[2024] += tr;
        data[2025] += ti;
        tr = data[2030];
        ti = data[2031];
        data[2030] = data[2026] - tr;
        data[2031] = data[2027] - ti;
        data[2026] += tr;
        data[2027] += ti;
    }
    // N = 8, at 2016
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 2024 ] * wr - data[ i + 2025 ] * wi;
            uniform float tempi  = data[ i + 2024 ] * wi + data[ i + 2025 ] * wr;
            uniform float tempr2 = data[ i + 2026 ] * wr2 - data[ i + 2027 ] * wi2;
            uniform float tempi2 = data[ i + 2026 ] * wi2 + data[ i + 2027 ] * wr2;
            data[ i + 2024 ] = data[ 2016 + i ] - tempr;
            data[ i + 2025 ] = data[ 2017 + i ] - tempi;
            data[ i + 2026 ] = data[ 2018 + i ] - tempr2;
            data[ i + 2027 ] = data[ 2019 + i ] - tempi2;
            data[ 2016 + i ] += tempr;
            data[ 2017 + i ] += tempi;
            data[ 2018 + i ] += tempr2;
            data[ 2019 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 4, at 2032
    {
        uniform float tr = data[2034];
        uniform float ti = data[2035];
        data[2034] = data[2032] - tr;
        data[2035] = data[2033] - ti;
        data[2032] += tr;
        data[2033] += ti;
        tr = data[2038];
        ti = data[2039];
        data[2038] = data[2037] - ti;
        data[2039] = tr - data[2036];
        data[2036] += tr;
        data[2037] += ti;
        tr = data[2036];
        ti = data[2037];
        data[2036] = data[2032] - tr;
        data[2037] = data[2033] - ti;
        data[2032] += tr;
        data[2033] += ti;
        tr = data[2038];
        ti = data[2039];
        data[2038] = data[2034] - tr;
        data[2039] = data[2035] - ti;
        data[2034] += tr;
        data[2035] += ti;
    }
    // N = 4, at 2040
    {
        uniform float tr = data[2042];
        uniform float ti = data[2043];
        data[2042] = data[2040] - tr;
        data[2043] = data[2041] - ti;
        data[2040] += tr;
        data[2041] += ti;
        tr = data[2046];
        ti = data[2047];
        data[2046] = data[2045] - ti;
        data[2047] = tr - data[2044];
        data[2044] += tr;
        data[2045] += ti;
        tr = data[2044];
        ti = data[2045];
        data[2044] = data[2040] - tr;
        data[2045] = data[2041] - ti;
        data[2040] += tr;
        data[2041] += ti;
        tr = data[2046];
        ti = data[2047];
        data[2046] = data[2042] - tr;
        data[2047] = data[2043] - ti;
        data[2042] += tr;
        data[2043] += ti;
    }
    // N = 8, at 2032
    {
        uniform const_expr float sina = -0.382683442348173696867519f;
        uniform const_expr float sinb = -0.707106795823699951775154f;

        uniform const_expr float wpr = -0.292893234094895982266848f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        // N=8
        for ( uniform size_t i = 0; i < 8; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 2040 ] * wr - data[ i + 2041 ] * wi;
            uniform float tempi  = data[ i + 2040 ] * wi + data[ i + 2041 ] * wr;
            uniform float tempr2 = data[ i + 2042 ] * wr2 - data[ i + 2043 ] * wi2;
            uniform float tempi2 = data[ i + 2042 ] * wi2 + data[ i + 2043 ] * wr2;
            data[ i + 2040 ] = data[ 2032 + i ] - tempr;
            data[ i + 2041 ] = data[ 2033 + i ] - tempi;
            data[ i + 2042 ] = data[ 2034 + i ] - tempr2;
            data[ i + 2043 ] = data[ 2035 + i ] - tempi2;
            data[ 2032 + i ] += tempr;
            data[ 2033 + i ] += tempi;
            data[ 2034 + i ] += tempr2;
            data[ 2035 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 16, at 2016
    {
        uniform const_expr float sina = -0.195090327360605081397082f;
        uniform const_expr float sinb = -0.382683442348173696867519f;

        uniform const_expr float wpr = -0.076120471659336108594118f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 16; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 2032 ] * wr - data[ i + 2033 ] * wi;
            uniform float tempi  = data[ i + 2032 ] * wi + data[ i + 2033 ] * wr;
            uniform float tempr2 = data[ i + 2034 ] * wr2 - data[ i + 2035 ] * wi2;
            uniform float tempi2 = data[ i + 2034 ] * wi2 + data[ i + 2035 ] * wr2;
            data[ i + 2032 ] = data[ 2016 + i ] - tempr;
            data[ i + 2033 ] = data[ 2017 + i ] - tempi;
            data[ i + 2034 ] = data[ 2018 + i ] - tempr2;
            data[ i + 2035 ] = data[ 2019 + i ] - tempi2;
            data[ 2016 + i ] += tempr;
            data[ 2017 + i ] += tempi;
            data[ 2018 + i ] += tempr2;
            data[ 2019 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 32, at 1984
    {
        uniform const_expr float sina = -0.098017143046549182194838f;
        uniform const_expr float sinb = -0.195090327360605081397082f;

        uniform const_expr float wpr = -0.019214720662015370711284f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 32; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 2016 ] * wr - data[ i + 2017 ] * wi;
            uniform float tempi  = data[ i + 2016 ] * wi + data[ i + 2017 ] * wr;
            uniform float tempr2 = data[ i + 2018 ] * wr2 - data[ i + 2019 ] * wi2;
            uniform float tempi2 = data[ i + 2018 ] * wi2 + data[ i + 2019 ] * wr2;
            data[ i + 2016 ] = data[ 1984 + i ] - tempr;
            data[ i + 2017 ] = data[ 1985 + i ] - tempi;
            data[ i + 2018 ] = data[ 1986 + i ] - tempr2;
            data[ i + 2019 ] = data[ 1987 + i ] - tempi2;
            data[ 1984 + i ] += tempr;
            data[ 1985 + i ] += tempi;
            data[ 1986 + i ] += tempr2;
            data[ 1987 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 64, at 1920
    {
        uniform const_expr float sina = -0.049067675691525959591477f;
        uniform const_expr float sinb = -0.098017143046549182194838f;

        uniform const_expr float wpr = -0.004815273595537535207545f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 64; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1984 ] * wr - data[ i + 1985 ] * wi;
            uniform float tempi  = data[ i + 1984 ] * wi + data[ i + 1985 ] * wr;
            uniform float tempr2 = data[ i + 1986 ] * wr2 - data[ i + 1987 ] * wi2;
            uniform float tempi2 = data[ i + 1986 ] * wi2 + data[ i + 1987 ] * wr2;
            data[ i + 1984 ] = data[ 1920 + i ] - tempr;
            data[ i + 1985 ] = data[ 1921 + i ] - tempi;
            data[ i + 1986 ] = data[ 1922 + i ] - tempr2;
            data[ i + 1987 ] = data[ 1923 + i ] - tempi2;
            data[ 1920 + i ] += tempr;
            data[ 1921 + i ] += tempi;
            data[ 1922 + i ] += tempr2;
            data[ 1923 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 128, at 1792
    {
        uniform const_expr float sina = -0.024541229205668591006884f;
        uniform const_expr float sinb = -0.049067675691525959591477f;

        uniform const_expr float wpr = -0.001204543861850321988596f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 128; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1920 ] * wr - data[ i + 1921 ] * wi;
            uniform float tempi  = data[ i + 1920 ] * wi + data[ i + 1921 ] * wr;
            uniform float tempr2 = data[ i + 1922 ] * wr2 - data[ i + 1923 ] * wi2;
            uniform float tempi2 = data[ i + 1922 ] * wi2 + data[ i + 1923 ] * wr2;
            data[ i + 1920 ] = data[ 1792 + i ] - tempr;
            data[ i + 1921 ] = data[ 1793 + i ] - tempi;
            data[ i + 1922 ] = data[ 1794 + i ] - tempr2;
            data[ i + 1923 ] = data[ 1795 + i ] - tempi2;
            data[ 1792 + i ] += tempr;
            data[ 1793 + i ] += tempi;
            data[ 1794 + i ] += tempr2;
            data[ 1795 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 256, at 1536
    {
        uniform const_expr float sina = -0.012271538627185888531423f;
        uniform const_expr float sinb = -0.024541229205668591006884f;

        uniform const_expr float wpr = -0.000301181320557030655742f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 256; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1792 ] * wr - data[ i + 1793 ] * wi;
            uniform float tempi  = data[ i + 1792 ] * wi + data[ i + 1793 ] * wr;
            uniform float tempr2 = data[ i + 1794 ] * wr2 - data[ i + 1795 ] * wi2;
            uniform float tempi2 = data[ i + 1794 ] * wi2 + data[ i + 1795 ] * wr2;
            data[ i + 1792 ] = data[ 1536 + i ] - tempr;
            data[ i + 1793 ] = data[ 1537 + i ] - tempi;
            data[ i + 1794 ] = data[ 1538 + i ] - tempr2;
            data[ i + 1795 ] = data[ 1539 + i ] - tempi2;
            data[ 1536 + i ] += tempr;
            data[ 1537 + i ] += tempi;
            data[ 1538 + i ] += tempr2;
            data[ 1539 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 512, at 1024
    {
        uniform const_expr float sina = -0.006135884819898434171248f;
        uniform const_expr float sinb = -0.012271538627185888531423f;

        uniform const_expr float wpr = -0.000075298165046120077719f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 512; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1536 ] * wr - data[ i + 1537 ] * wi;
            uniform float tempi  = data[ i + 1536 ] * wi + data[ i + 1537 ] * wr;
            uniform float tempr2 = data[ i + 1538 ] * wr2 - data[ i + 1539 ] * wi2;
            uniform float tempi2 = data[ i + 1538 ] * wi2 + data[ i + 1539 ] * wr2;
            data[ i + 1536 ] = data[ 1024 + i ] - tempr;
            data[ i + 1537 ] = data[ 1025 + i ] - tempi;
            data[ i + 1538 ] = data[ 1026 + i ] - tempr2;
            data[ i + 1539 ] = data[ 1027 + i ] - tempi2;
            data[ 1024 + i ] += tempr;
            data[ 1025 + i ] += tempi;
            data[ 1026 + i ] += tempr2;
            data[ 1027 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
    // N = 1024, at 0
    {
        uniform const_expr float sina = -0.003067956848339327760589f;
        uniform const_expr float sinb = -0.006135884819898434171248f;

        uniform const_expr float wpr = -0.000018824718446544360702f;
        uniform const_expr float wpi = sinb;
        uniform float wr = 1.0f;
        uniform float wi = 0.0f;
        for ( uniform size_t i = 0; i < 1024; i += 4 )
        {
            uniform float wtemp = wr;
            uniform float wr2 = wr + ( wr * wpr -    wi * wpi );
            uniform float wi2 = wi + ( wi * wpr + wtemp * wpi );
            
            uniform float tempr  = data[ i + 1024 ] * wr - data[ i + 1025 ] * wi;
            uniform float tempi  = data[ i + 1024 ] * wi + data[ i + 1025 ] * wr;
            uniform float tempr2 = data[ i + 1026 ] * wr2 - data[ i + 1027 ] * wi2;
            uniform float tempi2 = data[ i + 1026 ] * wi2 + data[ i + 1027 ] * wr2;
            data[ i + 1024 ] = data[ 0 + i ] - tempr;
            data[ i + 1025 ] = data[ 1 + i ] - tempi;
            data[ i + 1026 ] = data[ 2 + i ] - tempr2;
            data[ i + 1027 ] = data[ 3 + i ] - tempi2;
            data[ 0 + i ] += tempr;
            data[ 1 + i ] += tempi;
            data[ 2 + i ] += tempr2;
            data[ 3 + i ] += tempi2;
        
            wtemp = wr2;
            wr = wr2 + ( wr2 * wpr - wi2 * wpi);
            wi = wi2 + ( wi2 * wpr + wtemp * wpi);
        }
    }
}
