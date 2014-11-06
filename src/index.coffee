CronJob = require("cron").CronJob
_       = require 'underscore'

exportObj = (obj) ->
  return obj  if obj instanceof _
  return new test(obj)  unless this instanceof exportObj
  @_wrapped = obj
  return

exports = module.exports = exportObj;
exports.test = exportObj;


exportObj.create = (pattern, func, timezone) ->
	robot.emit "cron created", {
		pattern:	pattern,
		func:	func,e
		timezone: timezone
	}

module.exports = (robot) ->
	robot.brain.data.cronJobs ?= {}

  save = (obj) ->
  robot.brain.data.cronJobs.push obj

	robot.on "cron created", (cron) ->
		job = new Job cron.pattern, cron.func, cron.timezone
		save job
		job.startJob()	


class Job
  constructor: (@pattern, @func, @timezone) ->
    @id = this.generateID()

  generateID: () ->
    now = Date.now().toString()
    now.splice(now.length - 7, now.length)

  save: (robot) ->
    console.log "in save"
    robot.brain.data.cronJobs.push this

  startJob: () ->
    @cronJob.start()

  stopJob: () ->
    @cronJob.stop()

  createCron: (optionsHash) ->
    console.log "in create"
    @cronJob = new CronJob @pattern, =>
      @func(optionsHash)
    , ->
      console.log "job ended"
    , false
    , @timezone
    console.log "finished creating"






