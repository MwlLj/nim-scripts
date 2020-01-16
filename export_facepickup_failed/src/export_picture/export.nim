import "../consts/error"

# import json_serialization

import os
import db_sqlite
import json

type
    CExport = object
        targetDir: string
        dbPath: string

type
    CAngle = object
        pitch: float
        roll: float
        yaw: float

type
    CLocation = object
        height: int
        left: float
        rotation: int
        top: float
        width: int

type
    COcclusion = object
        chin_contour: int
        left_cheek: float
        left_eye: float
        mouth: float
        nose: float
        right_cheek: float
        right_eye: float

type
    CQuality = object
        blur: int
        completeness: int
        illumination: int
        occlusion: COcclusion

type
    CFeatureResult = object
        angle: CAngle
        face_probability: float
        face_token: string
        location: CLocation
        quality: CQuality

type
    CExtraInfo = object
        originalPhotoUri: string
        facePhotoUri: string
        featureResult: CFeatureResult
        size: int

proc exec*(self: CExport): error.ErrorCode =
    #[
    ## 参数是否有效
    ##  1. dbPath 是否存在
    ##  2. targetDir 是否存在
    ]#
    if os.existsFile(self.dbPath) == false:
        return error.ErrorCode.NotExistError
    if os.existsDir(self.targetDir) == false:
        os.createDir(self.targetDir)
    #[
    ## 查询没有提取成功的所有信息
    ]#
    let db = db_sqlite.open(self.dbPath, "", "", "")
    for row in db.instantRows(sql"""
        select spi.extra_info from t_staff_info as si
        inner join t_staff_photo_info as spi
        on si.staff_uuid = spi.staff_uuid
        where spi.is_pickup_success = 0;
        """):
        let extraInfoStr = row[0]
        # echo(extraInfoStr)
        let jsonNode = parseJson(extraInfoStr)
        var extraInfo = to(jsonNode, CExtraInfo)
        let uri = extraInfo.originalPhotoUri
        # let extraInfo = Json.decode(extraInfoStr, CExtraInfo)
        # let uri = extraInfo.originalPhotoUri
        var (dir, name, ext) = os.splitFile(uri)
        name.add(ext)
        let t = os.joinPath(self.targetDir, name)
        echo(uri, " => ", t)
        os.copyFile(uri, t)
    db.close()
    return error.ErrorCode.Success

proc newExport*(targetDir: string, dbPath: string): CExport =
    let e = CExport(
        targetDir: targetDir,
        dbPath: dbPath
        )
    return e
