package com._4paradigm.fesql.spark

import java.nio.ByteBuffer

import com._4paradigm.fesql.`type`.TypeOuterClass.Type
import com._4paradigm.fesql.common.SerializableByteBuffer
import com._4paradigm.fesql.spark.nodes._
import com._4paradigm.fesql.vm._
import org.apache.spark.broadcast.Broadcast
import org.apache.spark.sql.types._
import org.apache.spark.sql.{DataFrame, SparkSession}

import scala.collection.mutable

class PlanContext(tag: String, session: SparkSession, planner: SparkPlanner, config: Map[String, Any]) {

  private var moduleBuffer: SerializableByteBuffer = _
  // private var moduleBroadCast: Broadcast[SerializableByteBuffer] = _

  private val planResults = mutable.HashMap[Long, SparkInstance]()

  private val namedSparkDataFrames = mutable.HashMap[String, DataFrame]()

  def getTag: String = tag

  def getSparkSession: SparkSession = session

  def setModuleBuffer(buf: ByteBuffer): Unit = {
    moduleBuffer = new SerializableByteBuffer(buf)
    // moduleBroadCast = session.sparkContext.broadcast(moduleBuffer)
  }

  def getModuleBuffer: ByteBuffer = moduleBuffer.getBuffer

  def getSerializableModuleBuffer: SerializableByteBuffer = moduleBuffer

  // def getModuleBufferBroadcast: Broadcast[SerializableByteBuffer] = moduleBroadCast

  def getPlanResult(node: PhysicalOpNode): Option[SparkInstance] = {
    planResults.get(PhysicalOpNode.getCPtr(node))
  }

  def putPlanResult(node: PhysicalOpNode, res: SparkInstance): Unit = {
    planResults += PhysicalOpNode.getCPtr(node) -> res
  }

  def registerDataFrame(name: String, df: DataFrame): Unit = {
    namedSparkDataFrames += name -> df
  }

  def getDataFrame(name: String): Option[DataFrame] = {
    namedSparkDataFrames.get(name)
  }

  def getConf[T](key: String, default: T): T = {
    config.getOrElse(key, default).asInstanceOf[T]
  }

  def visitPhysicalNodes(root: PhysicalOpNode): SparkInstance = {
    planner.visitPhysicalNodes(root, this)
  }
}

